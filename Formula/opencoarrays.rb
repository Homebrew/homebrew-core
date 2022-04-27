class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://www.opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.9.3/OpenCoarrays-2.9.3.tar.gz"
  sha256 "eeee0b3be665022ab6838c523ddab4af9c948d4147afd6cd7bc01f028583cfe1"
  license "BSD-3-Clause"
  head "https://github.com/sourceryinstitute/opencoarrays.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1656b91f52e8c487d9ac27c6509abc23b36f37ecf4e6a188e9b736db4893ac53"
    sha256 cellar: :any,                 arm64_big_sur:  "043b88d4bf48347702c50ba3438389965196d9970216b9464561fb31628a0b71"
    sha256 cellar: :any,                 monterey:       "b9fb0046ab439e447ba55678666b20647915ad640754c5a5016cb0b05889ad2d"
    sha256 cellar: :any,                 big_sur:        "837d197c743e950acdffe9ee52e63d4191c67226242c53ad7e9a26221a5e73f5"
    sha256 cellar: :any,                 catalina:       "245e140d9b5b8301caab320267ab2ff0c83156f60433181afdfce370651292ab"
    sha256 cellar: :any,                 mojave:         "cf781f8c51d7b6bf872e1c0879ad22f287ff3c22b49118eb5e1f3a172cfaedad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db09effd8c16b9cc640120bfd01ba6fc666d4086faa0f13efe20962c0072dd80"
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
  end
end
