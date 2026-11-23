class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "https://www.opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/archive/refs/tags/2.11.0.tar.gz"
  sha256 "2444f2083df3654675cc5563d0391885969b03db94c5b6cb522c85918a48f878"
  license "BSD-3-Clause"
  head "https://github.com/sourceryinstitute/opencoarrays.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "ac8b98d75fd5a96c6ef907d9bdfab0e42be7049c0caba2f6788dca2be0c3f051"
    sha256 cellar: :any,                 arm64_tahoe:       "d1754a06e742ffd50f899af3cf5a186a43aaff6960e26806587e3613589dbd7b"
    sha256 cellar: :any,                 arm64_sequoia:     "a4946c282cb6a26c68ce00264b72cbe34fc9c11809a9fa2264a8eb4e9654e132"
    sha256 cellar: :any,                 arm64_sonoma:      "7845bf8f56d7a2053eb7a23484a94bb3800d9fafc9385b6c19f4443be04b84f6"
    sha256 cellar: :any,                 sonoma:            "15f31976e5b9b76817ce2c9e1967f2a88d5bcaa7ff363bdbb9935e6e903c7eb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4399e9520d9d42d1df399004733966a82f39cb35b04a9917a088fa3fe8b0e83a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5518987ba0c0912603c3d75480c1cb80285c5608362155d374804f94d0332a06"
  end

  depends_on "cmake" => :build
  depends_on "gcc@14"
  depends_on "open-mpi"

  def install
    # OpenCoarrays blocks building with Open MPI and GFortran 15+.
    # We don't support MPICH dependency as a single MPI is needed across formulae
    #
    # Ref: https://github.com/sourceryinstitute/OpenCoarrays/issues/793
    # Ref: https://github.com/open-mpi/ompi/issues/13385
    ENV["FC"] = which("gfortran-14")
    openmpi = Formula["open-mpi"]

    # Use `open-mpi` even if another MPI is linked into HOMEBREW_PREFIX, and keep
    # FindMPI from picking HOMEBREW_PREFIX/lib over the `mpifort -show` paths.
    args = %W[
      -DMPI_C_COMPILER=#{openmpi.opt_bin}/mpicc
      -DMPI_Fortran_COMPILER=#{openmpi.opt_bin}/mpifort
      -DMPIEXEC_EXECUTABLE=#{openmpi.opt_bin}/mpiexec
      -DCMAKE_FIND_USE_CMAKE_ENVIRONMENT_PATH=OFF
    ]

    # Build tests only for bottles, where they run below
    testing = build.bottle? ? "ON" : "OFF"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args, "-DBUILD_TESTING=#{testing}"
    system "cmake", "--build", "build"
    # Run test in CI to check if issues mixing direct gcc@14 with indirect gcc in open-mpi.
    # Avoid running on local source build as tests can be flaky (e.g. newer shellcheck installed)
    if build.bottle?
      with_env(PRTE_MCA_rmaps_default_mapping_policy: ":oversubscribe") do
        system "ctest", "--test-dir", "build", "--rerun-failed", "--output-on-failure", "--parallel", ENV.make_jobs
      end
    end
    system "cmake", "--install", "build"

    # Replace `open-mpi` Cellar path that breaks on `open-mpi` version/revision bumps.
    # CMake FindMPI uses REALPATH so there isn't a clean way to handle during generation.
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
    assert_match formula_opt_lib("open-mpi").to_s, shell_output("#{bin}/caf --show")
  end
end
