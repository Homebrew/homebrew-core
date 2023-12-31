class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://www.opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.10.1/OpenCoarrays-2.10.1.tar.gz"
  sha256 "b04b8fa724e7e4e5addbab68d81d701414e713ab915bafdf1597ec5dd9590cd4"
  license "BSD-3-Clause"
  revision 5
  head "https://github.com/sourceryinstitute/opencoarrays.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "50b0aa18dae7c0a861896370b53e9f74057c8390717224bc95293de31a3ad797"
    sha256 cellar: :any,                 arm64_ventura:  "33fd74fb80bd13d0107d49f4e4daa39892f88426fe114ff47d81e0efd6f5f7cb"
    sha256 cellar: :any,                 arm64_monterey: "0dd1070bc400a07c8719663795fbf284e37a70914c8f98a484d943e9b2ac27c9"
    sha256 cellar: :any,                 sonoma:         "fbac2a13b31651cea83ac1d245093fdf99cc64b284e1e25315405431da89ca13"
    sha256 cellar: :any,                 ventura:        "b51e97d0aca458d1dc0ed461e1cb8a872754f1459895a09f63b8ed50277f83f2"
    sha256 cellar: :any,                 monterey:       "61918bffe69b86ec47cd24828c68a18e8408319180ac86aa5c2c2eff58a72cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f3c68e7fd4a890bdc319edb796b1270837bc63845362cf1ad77123e7f6783d1"
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "open-mpi"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
