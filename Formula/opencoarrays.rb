class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.8.0/OpenCoarrays-2.8.0.tar.gz"
  sha256 "144238160a39a7efa8ae1f11f33b065d03e97171614c4b9ca127528578305b08"
  head "https://github.com/sourceryinstitute/opencoarrays.git"

  bottle do
    cellar :any
    sha256 "bebdfc7f6a331851bc441a8d703c19cc3adf03f5e89f96c214de94afabae324e" => :catalina
    sha256 "7d0fc39ca2027e0d25766dcc611735b69aa7cdcbf2ee9617f41efafcf8df9fd0" => :mojave
    sha256 "a91b2bc5491f7b9e1b56e39ae3d7aa8d6bc280600291134f75eef2aee48265e9" => :high_sierra
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
