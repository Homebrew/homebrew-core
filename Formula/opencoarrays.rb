class Opencoarrays < Formula
  desc "open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/1.8.10/OpenCoarrays-1.8.10.tar.gz"
  sha256 "69b61d2d3b171a294702efbddc8a602824e35a3c49ee394b41d7fb887001501a"

  head "https://github.com/sourceryinstitute/opencoarrays.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0532a093b6aaaa225932b8657353acf3ea427f3904e83b88e2c3f56dede48f73" => :sierra
    sha256 "43a9057a9c22987517a628c9f86277dc0a745c38aa1ad059ed9872ac88885b71" => :el_capitan
    sha256 "887128dcb8e89df7bebeb06c389fff3340cb6c88fbad80f83044b266cce89324" => :yosemite
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
