class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.3.1/OpenCoarrays-2.3.1.tar.gz"
  sha256 "2b87cc8c31874ecb01e0300bc99b30e4017714fc0d17690f637d8fa4d48560f3"
  head "https://github.com/sourceryinstitute/opencoarrays.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f9381136d912f0b101c3fae93853d374257a55b87902ffc0ba7929c610372a19" => :mojave
    sha256 "daf826a8943012133433f240d47dea04f3debedad6dcd92e27bf322344a3ce4b" => :high_sierra
    sha256 "96dca35e40409e14bc79bd8db5c956f389ef8b2d4969f7269ceb3649c8ebde5d" => :sierra
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
