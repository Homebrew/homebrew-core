class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://www.opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.10.2/OpenCoarrays-2.10.2.tar.gz"
  sha256 "e13f0dc54b966b0113deed7f407514d131990982ad0fe4dea6b986911d26890c"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/sourceryinstitute/opencoarrays.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "86b885bec80353c13fc3b5251709c25eb2301b6882d318f6accef9e6422c2061"
    sha256 cellar: :any,                 arm64_ventura:  "1ad5ad000ced5ecc2f25406e853b472eb021cffc1e69bc4323ae2855a84101cc"
    sha256 cellar: :any,                 arm64_monterey: "d8e3fac0c680d1b042c1230922b81de76a3d219ac08d6966b29ac0ec4b004c83"
    sha256 cellar: :any,                 sonoma:         "0f7f0c8f1bce8aee7dbae34223cdba331497d553e03e472bb9a629bbb677748a"
    sha256 cellar: :any,                 ventura:        "7a41f847a2485f22a93d8115cda03992d187fa5679fc0483937167a367478c7b"
    sha256 cellar: :any,                 monterey:       "f17b31f7f4321aa6259fa6f8b0e56dededec125eaf55661797c9e3e4db48611c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d204334861ce7332d844002f7cd8ec6a0ad56f991ed6a578130ff5ca5afab121"
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
