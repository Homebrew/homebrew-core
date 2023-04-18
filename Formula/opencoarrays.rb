class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://www.opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.10.1/OpenCoarrays-2.10.1.tar.gz"
  sha256 "b04b8fa724e7e4e5addbab68d81d701414e713ab915bafdf1597ec5dd9590cd4"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/sourceryinstitute/opencoarrays.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "afa986a39ef08bbf5552b8fc80df85533cfd75e5782e14acc3e5c02ca0aa4557"
    sha256 cellar: :any,                 arm64_monterey: "1286aebf495b4592259b352500d1ddcc320ebf5a2d4f9d553f5f9560936a0066"
    sha256 cellar: :any,                 arm64_big_sur:  "0d295a26c5caa4a6ac5e29e4250e4ffbff77ecd53656dfd9a5516d7646412887"
    sha256 cellar: :any,                 ventura:        "1a5dd670a537e4e12af2586c75de4b21f92092d01c16b3997e691563e6ff4676"
    sha256 cellar: :any,                 monterey:       "6185eb86dc801389a8dda416f2bd8dace59ec190d877af1b4149f8f4917d5312"
    sha256 cellar: :any,                 big_sur:        "92b9cd1f3ddba89e94c3c22c724965feef82a37eff0dabe1ca8e0b7851b5adc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5427d1b24fbb5825fca6dfd65725eecacf8936db3b1b2ea49d6b53e8a0229ff1"
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
