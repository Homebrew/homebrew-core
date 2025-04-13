class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://www.opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.10.2/OpenCoarrays-2.10.2.tar.gz"
  sha256 "e13f0dc54b966b0113deed7f407514d131990982ad0fe4dea6b986911d26890c"
  license "BSD-3-Clause"
  revision 5
  head "https://github.com/sourceryinstitute/opencoarrays.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e263b0b0243719cdaf1ef02de84c8d70c52b1ba4b75254e75eec540daba88fde"
    sha256 cellar: :any,                 arm64_sonoma:  "8c6e809fff5e543d60f2ee038ca04aa99e398a69b3aec9db067249c84b2beef0"
    sha256 cellar: :any,                 arm64_ventura: "343c2414094be734db3423e6c2fab208320996971c0475f27e9b4328e20307a3"
    sha256 cellar: :any,                 sonoma:        "bf66d20a900e5b7880971a9d5c0801cc9b18f3f4fded8be925bf482fb9b86d00"
    sha256 cellar: :any,                 ventura:       "6918670d6f5c0b401d2aaea00dc994ac8a5879ec7430c0212c058c7a8654f90e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "565fc597f9fee0da1af004bf3ac41b7b161468d4c6814e5d67fb2d3280a0a2ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3be56cc15f1203f55853c88f265444b90868d9228e88fc3c405b5219e401eab5"
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "open-mpi"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Replace `open-mpi` Cellar path that breaks on `open-mpi` version/revision bumps.
    # CMake FindMPI uses REALPATH so there isn't a clean way to handle during generation.
    openmpi = Formula["open-mpi"]
    inreplace_files = [bin/"caf", lib/"cmake/opencoarrays/OpenCoarraysTargets.cmake"]
    inreplace inreplace_files, openmpi.prefix.realpath, openmpi.opt_prefix
  end

  test do
    (testpath/"tally.f90").write <<~FORTRAN
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
    FORTRAN
    system bin/"caf", "tally.f90", "-o", "tally"
    system bin/"cafrun", "-np", "3", "--oversubscribe", "./tally"
    assert_match Formula["open-mpi"].opt_lib.to_s, shell_output("#{bin}/caf --show")
  end
end
