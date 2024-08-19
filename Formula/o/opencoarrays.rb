class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://www.opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.10.2/OpenCoarrays-2.10.2.tar.gz"
  sha256 "e13f0dc54b966b0113deed7f407514d131990982ad0fe4dea6b986911d26890c"
  license "BSD-3-Clause"
  revision 4
  head "https://github.com/sourceryinstitute/opencoarrays.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "184ee097de916fb71dbe738503878b7065b08b18f7f6d845ed840c1965fdf911"
    sha256 cellar: :any,                 arm64_ventura:  "99a88e8b98865f4e49a6b45668ae9ce17a2cb16a16a27601592867431f0556ed"
    sha256 cellar: :any,                 arm64_monterey: "2a75417b713d0ac5bd92e3fa3f8c9b5f6d2d6ce3112e760bca0857d9204cbcb4"
    sha256 cellar: :any,                 sonoma:         "789d54b40e2e9e7d887f579e7fda857a85ee724ebb719c476acf0515276cab07"
    sha256 cellar: :any,                 ventura:        "849c075171928fac437f75c62e716a0fbb646ddcdfab88852d4919d9309fde25"
    sha256 cellar: :any,                 monterey:       "19bc44371dbcb4bd9fc179ce0e5c2e4d29658dfb36d37017d85188c80c6b0411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b39e050aa00ddf5a88737051b4984cac7ea0550058ab6c036872c2252cffaa9"
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
    system bin/"caf", "tally.f90", "-o", "tally"
    system bin/"cafrun", "-np", "3", "--oversubscribe", "./tally"
    assert_match Formula["open-mpi"].lib.realpath.to_s, shell_output("#{bin}/caf --show")
  end
end
