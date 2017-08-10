class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/1.9.1/OpenCoarrays-1.9.1.tar.gz"
  sha256 "068a1c91c419aeeb87158cdbdf946fc6780d2ae929c179aa1adfd91344b36e74"

  head "https://github.com/sourceryinstitute/opencoarrays.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "714231165b8ff2f8b3b1f81b50baf7b451ea7e9eacb5d28fd74c65dd42b0ca86" => :sierra
    sha256 "0fed3f6f9dfb12490ae39a81436763b428f7a0fc4b3d1289f640699b04722324" => :el_capitan
    sha256 "e8d6a00623b6016b1536140f1225d2791c9697c3cc054e5a12150f01fa59b2a8" => :yosemite
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
