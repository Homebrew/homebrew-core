class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.9.0/OpenCoarrays-2.9.0.tar.gz"
  sha256 "0efaf5946955e449c4ee84036c950841dbc5f2546e0e20e7422fd70605720333"
  license "BSD-3-Clause"
  head "https://github.com/sourceryinstitute/opencoarrays.git"

  bottle do
    cellar :any
    sha256 "48bd64ed964c65972ee81dd6f9998e9d53ee4c14c90e2f887c0f2c63983ae79e" => :catalina
    sha256 "e73c0a505511aca5d03122dc2323229fdbf1f962ec214c45b6900b5524c1d41b" => :mojave
    sha256 "8e5787bb25f0c0b61c3260b264bb964a3dcf2d393f9ff1a4094e720b2769f6ad" => :high_sierra
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
