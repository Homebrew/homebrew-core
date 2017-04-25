class Opencoarrays < Formula
  desc "open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://opencoarrays.org"
  url "https://github.com/sourceryinstitute/opencoarrays/releases/download/1.8.6/OpenCoarrays-1.8.6.tar.gz"
  sha256 "1d560b5c39dd976fa73997545f86f8e996fda39ded01158195cd8fb16dd0991c"

  head "https://github.com/sourceryinstitute/opencoarrays.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c57bc9e52fe97c25233cfbadbf2f4b74fc34f6e511b1707e876ea2e0af8787cf" => :sierra
    sha256 "be6af7a4bd1b7ed28e3791f0f6435ee8ea8c6c5b6c60faf9c21979376133ab45" => :el_capitan
    sha256 "aae6cd30732b16834faa7b9fa497e14fd2e6f5110fc4f307afd1a6723697bc3d" => :yosemite
  end

  option "without-test", "Skip build time tests (not recommended)"

  depends_on "gcc"
  depends_on :fortran
  depends_on :mpi => :cc
  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "ctest", "--output-on-failure", "--schedule-random" if build.with? "test"
      system "make", "install"
    end
  end

  test do
    ENV.fortran
    (testpath/"tally.f90").write <<-EOS.undent
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
    system "#{bin}/cafrun", "-np", "3", "./tally"
  end
end
