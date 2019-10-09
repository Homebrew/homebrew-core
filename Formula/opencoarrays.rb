class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.8.0/OpenCoarrays-2.8.0.tar.gz"
  sha256 "144238160a39a7efa8ae1f11f33b065d03e97171614c4b9ca127528578305b08"
  head "https://github.com/sourceryinstitute/opencoarrays.git"

  bottle do
    cellar :any
    sha256 "3e78e55518c605b990004058e0a7f95a30f1eba792ba8d2dcb35eb4a4ce5968b" => :mojave
    sha256 "479394f97b42b598227c3c353f69a93ebaceeb73dda4ca216eb52a5970a266f9" => :high_sierra
    sha256 "623a45487cad21243cdd1ddfbb4b5220176c690f27f0f3e6a65d3a1e77503dd5" => :sierra
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
