class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://www.opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.10.0/OpenCoarrays-2.10.0.tar.gz"
  sha256 "c08717aea6ed5c68057f80957188a621b9862ad0e1460470e7ec82cdd84ae798"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/sourceryinstitute/opencoarrays.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d2fd4f8c6e64fffd15b4fb795de364eb467115d27bbcf71c99a6d939f542dedd"
    sha256 cellar: :any,                 arm64_big_sur:  "6684abc4a457e0070050540e33039e67e029bf67e9c70d0d71cf19f937eaaea8"
    sha256 cellar: :any,                 monterey:       "0ee047c89942d0107278bb8e6eae2df44ad29aee0ba43174742ef99e95c18e59"
    sha256 cellar: :any,                 big_sur:        "210cabf6956d14b6b36ca287dc6109032302ba449904b4ba8416cd02ac09899e"
    sha256 cellar: :any,                 catalina:       "3178664ff0f5396520e247b571d9659794a19016ac07d5072cbde44dea58ff37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d66f679245fc38459780bb21b4523c446710cb837a3954e21904700e39c4bd6"
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
    assert_match Formula["open-mpi"].lib.realpath.to_s, shell_output("#{bin}/caf --show")
  end
end
