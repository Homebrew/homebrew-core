class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http://www.opencoarrays.org"
  url "https://github.com/sourceryinstitute/OpenCoarrays/releases/download/2.10.2/OpenCoarrays-2.10.2.tar.gz"
  sha256 "e13f0dc54b966b0113deed7f407514d131990982ad0fe4dea6b986911d26890c"
  license "BSD-3-Clause"
  revision 5
  head "https://github.com/sourceryinstitute/opencoarrays.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e5eb18fc59c6f475e11f404cfc5f6d05e856bce5e6513e5573001a644f9e2d74"
    sha256 cellar: :any,                 arm64_sequoia: "4e5f645394d698c3f4b52fd2c57db55a78bf28de6b07c40df999681e96eb7620"
    sha256 cellar: :any,                 arm64_sonoma:  "e643b4c38c1d09c076eb61ebe972256b0cbc83b59f0386007c00188aea83145d"
    sha256 cellar: :any,                 sonoma:        "aab8992088d17d826340b910a5710062d3835b5df3c1d2e944245b4695940054"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06a03424802a7638edee660947add4dbe87e6bce8146047d7d7935f571e450d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a695a2cb428c5a6a651f5752ccfbd95f0fe60871107a4f449380192804874290"
  end

  depends_on "cmake" => :build
  depends_on "gcc@14"
  depends_on "open-mpi"

  def install
    # Version 2.10.2 and older are incompatible with GFortran 15.
    # Version 2.10.3 is incompatible with Open MPI when using GFortran 15.
    # We don't support MPICH dependency as a single MPI is needed across formulae
    #
    # Ref: https://github.com/sourceryinstitute/OpenCoarrays/issues/793
    # Ref: https://github.com/open-mpi/ompi/issues/13385
    ENV["FC"] = which("gfortran-14")

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
