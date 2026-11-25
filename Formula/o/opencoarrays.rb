class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "https://www.opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/archive/refs/tags/2.11.0.tar.gz"
  sha256 "2444f2083df3654675cc5563d0391885969b03db94c5b6cb522c85918a48f878"
  license "BSD-3-Clause"
  head "https://github.com/sourceryinstitute/opencoarrays.git", branch: "main"

  bottle do
    manifest_sha256 "f2f598af8f96d37a2d5ae54366f28d07d19648744003b396531e594f2aac22f8"
    sha256 cellar: :any, arm64_golden_gate: "55143e44e60d610c878cfd7e842442bc107c617dd12c5bb95f4abd11ab5b2309"
    sha256 cellar: :any, arm64_tahoe:       "0aee1c0422b4f8a3ac51a85ec8cb91301290a469af862012c168f87dd6cc46cb"
    sha256 cellar: :any, arm64_sequoia:     "9231a9bd05d305efc9bb1c2879ce2db374f20bbfe7ed69a50ef5fedadfdae467"
    sha256 cellar: :any, arm64_linux:       "b66dbb69e881db2b45e9035297275652378fb35d5d21abe8cd67c6c62bff3bc7"
    sha256 cellar: :any, x86_64_linux:      "9f58af96570ec836ccc9ba8bf81d08b522966cb151fb4722dc72cf18cdbfa0d0"
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
