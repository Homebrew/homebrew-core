class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://www.opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.10.1/OpenCoarrays-2.10.1.tar.gz"
  sha256 "b04b8fa724e7e4e5addbab68d81d701414e713ab915bafdf1597ec5dd9590cd4"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/sourceryinstitute/opencoarrays.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ed73c71f20c55b8579c80aad6f77c05dcc8405cd05ec976783bbbf83974b62dc"
    sha256 cellar: :any,                 arm64_monterey: "b4421a52794d88cef51506d2c0a6ecade853137be875224088de7b761a95cbbc"
    sha256 cellar: :any,                 arm64_big_sur:  "1851664bdacbf6b33afcb9463245e2e90ebcfd0c7fde17de0914cb72f49f62e1"
    sha256 cellar: :any,                 ventura:        "5133280fc1b9d86d71c6fcb15162ca0a0ae4b0130d42eda23b96086cf87f6487"
    sha256 cellar: :any,                 monterey:       "e65dfdb42abbdeab9b11778f9a3e2ba0abfda203cc2ae0f1c794f1244291fabf"
    sha256 cellar: :any,                 big_sur:        "5d8fd75a48e06460eaa961234b39e0347509291b68658ec5af62339223f061d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64836eb0a028cbea86163aa78642b0f6f1d9f7c7b10d6ba28c170f484fe9d360"
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "open-mpi"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"tally.f90").write <<~EOS
      program main
        use iso_c_binding, only : c_int
        use iso_fortran_env, only : error_unit
        implicit none
        integer(c_int) :: tally
        tally = this_image() ! this image's contribution
        call co_sum(tally)
        verify: block
          integer(c_int) :: image
          if (tally/=sum([(image,image=1,num_images())])) then
             write(error_unit,'(a,i5)') "Incorrect tally on image ",this_image()
             error stop 2
          end if
        end block verify
        ! Wait for all images to pass the test
        sync all
        if (this_image()==1) write(*,*) "Test passed"
      end program
    EOS
    system "#{bin}/caf", "tally.f90", "-o", "tally"
    system "#{bin}/cafrun", "-np", "3", "--oversubscribe", "./tally"
    assert_match Formula["open-mpi"].lib.realpath.to_s, shell_output("#{bin}/caf --show")
  end
end
