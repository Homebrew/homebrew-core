class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://www.opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.10.2/OpenCoarrays-2.10.2.tar.gz"
  sha256 "e13f0dc54b966b0113deed7f407514d131990982ad0fe4dea6b986911d26890c"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/sourceryinstitute/opencoarrays.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8634e54e9c138059aa3db74266bd2adc087748362d31c50bb37a96a8d16fc967"
    sha256 cellar: :any,                 arm64_ventura:  "bba3fa0e77bd90ac55fd77bb1098b64a20e988014a316f65b399c7ecce2abe26"
    sha256 cellar: :any,                 arm64_monterey: "006ccf317093b6751a22052c630aa1d1a72635d27962962014d3a343e2fda3ed"
    sha256 cellar: :any,                 sonoma:         "419a3bf2be98e546374e3efc012e11fd5423a9a6f7b93fb4cbc385115a480e5e"
    sha256 cellar: :any,                 ventura:        "240ca2297f35090aa9eb1ec9c4b51eb9801baaf26b78306b80976e060ea379a5"
    sha256 cellar: :any,                 monterey:       "54da9e5906dacd91e476b19c594f237a8413ac46a9e4d41821a7f08539004517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fea7590b0103f4ebb92bd2869ce5a177ba34840284d0a3b1ead175fd626243da"
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "open-mpi"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
