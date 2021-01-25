class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.9.2/OpenCoarrays-2.9.2.tar.gz"
  sha256 "6c200ca49808c75b0a2dfa984304643613b6bc77cc0044bee093f9afe03698f7"
  license "BSD-3-Clause"
  head "https://github.com/sourceryinstitute/opencoarrays.git"

  bottle do
    cellar :any
    sha256 "c9c5f9e2866851c6d991a636e146e5847632000228f2dff63e8ea64cb6cea621" => :big_sur
    sha256 "ae408eed3714792c3f7f725971ed131da9ae17606179431c6070bf5617a9644a" => :arm64_big_sur
    sha256 "fadee1f47dc7c188886973395667274bd8c5af6e095cc1e6a427758f7d5ed931" => :catalina
    sha256 "fd57ea0d2ce0624a7bece27b2b9022d809c9665d899eed7c4840270909514e9c" => :mojave
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
