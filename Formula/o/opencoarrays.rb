class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://www.opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.10.1/OpenCoarrays-2.10.1.tar.gz"
  sha256 "b04b8fa724e7e4e5addbab68d81d701414e713ab915bafdf1597ec5dd9590cd4"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/sourceryinstitute/opencoarrays.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a477b7029d808f2d5440d127a14981b72307fda5e029c62c82b0b40dd31cdb52"
    sha256 cellar: :any,                 arm64_ventura:  "1d8eedb707ecd9e90fcb2df1a4165f2bd4564ddb327ffa5eb04a86ae50bb1720"
    sha256 cellar: :any,                 arm64_monterey: "47579db07f08f1a37d57074c9229b3e5096c7b28383c82f443272eb7834551e1"
    sha256 cellar: :any,                 sonoma:         "f80f1659a4680bb98d1959ae0842a2e3e53fa72e46db7857d2b9b0ce0c60808f"
    sha256 cellar: :any,                 ventura:        "6ecaa063d11da1d6511669c9abe62f956d506fabfd265cdeac7395060d906d50"
    sha256 cellar: :any,                 monterey:       "9e764b1b99c3ef5222b571351541b2113572dbcf61ed9069cc25d16322a0ab0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91960be9e06c76e42e7ceff1420d4c01928e85d309ca6bd4ecca6fe1bfb9fd3d"
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
