class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://www.opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/archive/refs/tags/2.10.3.tar.gz"
  sha256 "f9f2fb6ac1fe92c1ea66976894b5cebe53812827b7d1238fed933e2845e8a022"
  license "BSD-3-Clause"
  head "https://github.com/sourceryinstitute/opencoarrays.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d1754a06e742ffd50f899af3cf5a186a43aaff6960e26806587e3613589dbd7b"
    sha256 cellar: :any,                 arm64_sequoia: "a4946c282cb6a26c68ce00264b72cbe34fc9c11809a9fa2264a8eb4e9654e132"
    sha256 cellar: :any,                 arm64_sonoma:  "7845bf8f56d7a2053eb7a23484a94bb3800d9fafc9385b6c19f4443be04b84f6"
    sha256 cellar: :any,                 sonoma:        "15f31976e5b9b76817ce2c9e1967f2a88d5bcaa7ff363bdbb9935e6e903c7eb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4399e9520d9d42d1df399004733966a82f39cb35b04a9917a088fa3fe8b0e83a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5518987ba0c0912603c3d75480c1cb80285c5608362155d374804f94d0332a06"
  end

  depends_on "cmake" => :build
  depends_on "gcc@13"
  depends_on "open-mpi"

  def install
    # Version 2.10.2 and older are incompatible with GFortran 15.
    # Version 2.10.3 blocks building with Open MPI and GFortran 14+.
    # We don't support MPICH dependency as a single MPI is needed across formulae
    #
    # Ref: https://github.com/sourceryinstitute/OpenCoarrays/issues/793
    # Ref: https://github.com/open-mpi/ompi/issues/13385
    ENV["FC"] = which("gfortran-13")

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    # Run test in CI to check if issues mixing direct gcc@14 with indirect gcc in open-mpi.
    # Avoid running on local source build as tests can be flaky (e.g. newer shellcheck installed)
    if build.bottle?
      # Ignore a shellcheck error from ctest if CMake finds locally installed shellcheck
      with_env(PRTE_MCA_rmaps_default_mapping_policy: ":oversubscribe", SHELLCHECK_OPTS: "-e SC2329") do
        system "ctest", "--test-dir", "build", "--rerun-failed", "--output-on-failure", "--parallel", ENV.make_jobs
      end
    end
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
