class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/1.9.2/OpenCoarrays-1.9.2.tar.gz"
  sha256 "c0b872db5449d0f3e405427e3953e81e9ca78199fe55651898d3f2ff9b3690c8"
  revision 1
  head "https://github.com/sourceryinstitute/opencoarrays.git"

  bottle do
    cellar :any
    sha256 "8a4624c38b7eaa55fecace13cf4a85bde56638eb6261a462df4f9741c4a6bab1" => :high_sierra
    sha256 "e522dc3a089edea848a07fc4a9c7ae95b20f57f13936ea6ccaf36c3114960039" => :sierra
    sha256 "64891872abcb2b7193112ed5a24d02e4568900bf200e34c865fb34009a241e25" => :el_capitan
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
    system "#{bin}/cafrun", "-np", "3", "./tally"
  end
end
