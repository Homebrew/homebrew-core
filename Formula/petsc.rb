class Petsc < Formula
  desc "Scalable solution of models that use partial differential equations"
  homepage "https://www.mcs.anl.gov/petsc/index.html"
  url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.7.6.tar.gz"
  sha256 "b07f7b4e57d75f982787bd8169f7b8debd5aee2477293da230ab6c80a52c6ef8"
  head "https://bitbucket.org/petsc/petsc", :using => :git

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "open-mpi"

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "hypre"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "scalapack"
  depends_on "suite-sparse"

  def install
    # PETSc is not threadsafe, disable pthread/openmp
    # (see http://www.mcs.anl.gov/petsc/miscellaneous/petscthreads.html)
    args = %W[CC=mpicc
              CXX=mpicxx
              F77=mpif77
              FC=mpif90
              --with-debugging=0
              --with-openmp=0
              --with-pthread=0
              --with-shared-libraries=1
              --with-ssl=0
              --with-x=0
              --with-hdf5-dir=#{Formula["hdf5"].opt_prefix}
              --with-hwloc-dir=#{Formula["hwloc"].opt_prefix}
              --with-hypre-dir=#{Formula["hypre"].opt_prefix}
              --with-metis-dir=#{Formula["metis"].opt_prefix}
              --with-netcdf-dir=#{Formula["netcdf"].opt_prefix}
              --with-scalapack-dir=#{Formula["scalapack"].opt_prefix}
              --with-suitesparse-dir=#{Formula["suite-sparse"].opt_prefix}]

    # Build PETSc for real (vs. complex) numbers
    ENV["PETSC_DIR"] = Dir.getwd
    ENV["PETSC_ARCH"] = "real"
    args_real = %W[--prefix=#{prefix}/real
                   --with-scalar-type=real]
    system "./configure", *(args + args_real)
    system "make", "all", "--makefile=gmakefile"
    system "make", "install"

    # PETSc produces some non-executables in bin dir; do not link these
    ln_s "#{prefix}/real/bin/*.py", bin.to_s
    ln_s "#{prefix}/real/include", include.to_s
    ln_s "#{prefix}/real/lib", lib.to_s
  end

  test do
    (testpath/"test.c").write <<~EOS
    static char help[] = "Solve a tridiagonal linear system with KSP.\\n";
    #include <petscksp.h>
    #undef __FUNCT__
    #define __FUNCT__ "main"
    int main(int argc,char **args) {
      Vec            x, b, u;
      Mat            A;
      KSP            ksp;
      PC             pc;
      PetscReal      norm, tol=1.e-14;
      PetscErrorCode ierr;
      PetscInt i, n=10, col[3], its;
      PetscMPIInt size;
      PetscScalar neg_one=-1.0, one=1.0, value[3];
      PetscInitialize(&argc, &args, (char*)0, help);
      ierr = MPI_Comm_size(PETSC_COMM_WORLD, &size); CHKERRQ(ierr);
      if (size != 1) SETERRQ(PETSC_COMM_WORLD, 1, "This is a uniprocessor example only!\\n");

      /* Create vectors */
      ierr = VecCreate(PETSC_COMM_WORLD, &x); CHKERRQ(ierr);
      ierr = PetscObjectSetName((PetscObject) x, "Solution"); CHKERRQ(ierr);
      ierr = VecSetSizes(x, PETSC_DECIDE, n); CHKERRQ(ierr);
      ierr = VecSetFromOptions(x); CHKERRQ(ierr);
      ierr = VecDuplicate(x, &b); CHKERRQ(ierr);
      ierr = VecDuplicate(x, &u); CHKERRQ(ierr);

      /* Create matrix */
      ierr = MatCreate(PETSC_COMM_WORLD, &A); CHKERRQ(ierr);
      ierr = MatSetSizes(A, PETSC_DECIDE, PETSC_DECIDE, n, n); CHKERRQ(ierr);
      ierr = MatSetFromOptions(A); CHKERRQ(ierr);
      ierr = MatSetUp(A); CHKERRQ(ierr);

      /* Setup linear system */
      value[0] = -1.0; value[1] = 2.0; value[2] = -1.0;
      for (i = 1; i < n-1; i++) {
        col[0] = i-1; col[1] = i; col[2] = i+1;
        ierr = MatSetValues(A, 1, &i, 3, col, value, INSERT_VALUES); CHKERRQ(ierr);
      }
      i = n-1; col[0] = n-2; col[1] = n-1;
      ierr = MatSetValues(A, 1, &i, 2, col, value, INSERT_VALUES); CHKERRQ(ierr);
      i = 0; col[0] = 0; col[1] = 1; value[0] = 2.0; value[1] = -1.0;
      ierr = MatSetValues(A, 1, &i, 2, col, value, INSERT_VALUES); CHKERRQ(ierr);
      ierr = MatAssemblyBegin(A, MAT_FINAL_ASSEMBLY); CHKERRQ(ierr);
      ierr = MatAssemblyEnd(A, MAT_FINAL_ASSEMBLY); CHKERRQ(ierr);

      ierr = VecSet(u, one); CHKERRQ(ierr);
      ierr = MatMult(A, u, b); CHKERRQ(ierr);

      /* Create linear solver */
      ierr = KSPCreate(PETSC_COMM_WORLD, &ksp); CHKERRQ(ierr);
      ierr = KSPSetOperators(ksp, A, A); CHKERRQ(ierr);
      ierr = KSPGetPC(ksp, &pc); CHKERRQ(ierr);
      ierr = PCSetType(pc, PCJACOBI); CHKERRQ(ierr);
      ierr = KSPSetTolerances(ksp, 1.e-8, PETSC_DEFAULT, PETSC_DEFAULT, PETSC_DEFAULT);CHKERRQ(ierr);

      /* Solve */
      ierr = KSPSolve(ksp, b, x); CHKERRQ(ierr);
      ierr = KSPView(ksp, PETSC_VIEWER_STDOUT_WORLD); CHKERRQ(ierr);

      /* Check solution */
      ierr = VecAXPY(x, neg_one, u); CHKERRQ(ierr);
      ierr = VecNorm(x, NORM_2, &norm); CHKERRQ(ierr);
      ierr = KSPGetIterationNumber(ksp, &its); CHKERRQ(ierr);
      ierr = PetscPrintf(PETSC_COMM_WORLD, "Norm of error %g\\nIterations %D\\n",
                         (double)norm, its); CHKERRQ(ierr);

      /* Free work space */
      ierr = VecDestroy(&x); CHKERRQ(ierr); ierr = VecDestroy(&u); CHKERRQ(ierr);
      ierr = VecDestroy(&b); CHKERRQ(ierr); ierr = MatDestroy(&A); CHKERRQ(ierr);
      ierr = KSPDestroy(&ksp); CHKERRQ(ierr);

      ierr = PetscFinalize();
      return 0;
    }
    EOS
    system "mpicc", "test.c", "-I#{include}", "-L#{lib}", "-lpetsc", "-o", "test"
    assert (`./test | grep 'Norm of error' | awk '{print $NF}'`.to_f < 1.0e-8)
  end
end
