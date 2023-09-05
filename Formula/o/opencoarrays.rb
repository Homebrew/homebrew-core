class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://www.opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.10.1/OpenCoarrays-2.10.1.tar.gz"
  sha256 "b04b8fa724e7e4e5addbab68d81d701414e713ab915bafdf1597ec5dd9590cd4"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/sourceryinstitute/opencoarrays.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "34ac30208c143808ef8ba9c70f0e8a4e025fa2772878a3d7ee294378bd98eae9"
    sha256 cellar: :any,                 arm64_monterey: "c949b97866c6b19884a3547575306bf3d288e1cad006a8e987e2d29fa4f13708"
    sha256 cellar: :any,                 arm64_big_sur:  "e07007d8dc742feaab1455322b5b9d39375c30712e354fab23ee8f8db5df596d"
    sha256 cellar: :any,                 ventura:        "5424c08546ff3c93f549fddee86f76d1923e6b3ec8710e8d13d88e508a31e355"
    sha256 cellar: :any,                 monterey:       "f7997c9dde7fd5e028a013e9f1d68a2cf5e12cdc59f44f7abd8012f0d1abeca1"
    sha256 cellar: :any,                 big_sur:        "8e7707061f7929fbe390b77a64e1ec4f86b1c192dd7cb356a5694bb7f262a893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a08a0be9d6bab631c11027a255d67e9855249c3fd779f66476213573541aa4d6"
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
