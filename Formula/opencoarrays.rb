class Opencoarrays < Formula
  desc "open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://opencoarrays.org"
  url "https://github.com/sourceryinstitute/opencoarrays/releases/download/1.8.6/OpenCoarrays-1.8.6.tar.gz"
  sha256 "1d560b5c39dd976fa73997545f86f8e996fda39ded01158195cd8fb16dd0991c"

  head "https://github.com/sourceryinstitute/opencoarrays.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "526c1965dc39057c74e00b3d43c0adf87b7a1d7aaa662c54aac6beabf7dbc6ac" => :sierra
    sha256 "cc125c4d2f8bb474bb0eefa981b8c0e90e67b1a4f1d899d6e826ec427c37781d" => :el_capitan
    sha256 "acf92ff8727902cf6b19a7b4905cc804fdbebfe774bba180c2dbfc8f8430cedb" => :yosemite
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
