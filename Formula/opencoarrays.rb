class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://www.opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.10.0/OpenCoarrays-2.10.0.tar.gz"
  sha256 "c08717aea6ed5c68057f80957188a621b9862ad0e1460470e7ec82cdd84ae798"
  license "BSD-3-Clause"
  head "https://github.com/sourceryinstitute/opencoarrays.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "12025b2cffbdf384b4fbc22ccb13b10effb1e17cea17c60170c1060a1bba93e9"
    sha256 cellar: :any,                 arm64_big_sur:  "97d12fe587098d8e24adc53ad46a79a0fdee8c24131c08c781447e06ad9a17b4"
    sha256 cellar: :any,                 monterey:       "959322cd48edc9261cc96d8813424b971a8af6ee0360cb1f5e330c5bc27cce25"
    sha256 cellar: :any,                 big_sur:        "bb1f1d792c96e597318b1f9f78c30c3ad62f86882aac7f6d57832cc4be811571"
    sha256 cellar: :any,                 catalina:       "29634a4576165909d016f544bec0bccc65d42ff8a33eaec14cc5dd02bfc62f7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fa5e7a3e3f04836c60cc8db92b810eabf458a65271bdadd33cde4b3ff3d74be"
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
