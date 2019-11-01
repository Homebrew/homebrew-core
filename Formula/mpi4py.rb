class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.readthedocs.io"
  url "https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-3.0.2.tar.gz"
  sha256 "f8d629d1e3e3b7b89cb99d0e3bc5505e76cc42089829807950d5c56606ed48e0"

  depends_on "cython" => :build
  depends_on "open-mpi"
  depends_on "python"

  def install
    system "#{Formula["python"].opt_bin}/python3",
           *Language::Python.setup_install_args(libexec)

    system "python3", "setup.py",
      "build", "--mpicc=mpicc -shared", "--parallel=#{ENV.make_jobs}",
      "install", "--prefix=#{prefix}",
      "--single-version-externally-managed", "--record=installed.txt"
  end

  test do
    system "#{Formula["python"].opt_bin}/python3",
           "-c", "import mpi4py"
    system "#{Formula["python"].opt_bin}/python3",
           "-c", "import mpi4py.MPI"
    system "#{Formula["python"].opt_bin}/python3",
           "-c", "import mpi4py.futures"
    system "mpiexec", "-n", "4", "#{Formula["python"].opt_bin}/python3",
           "-m", "mpi4py.run", "-m", "mpi4py.bench", "helloworld"
    system "mpiexec", "-n", "4", "#{Formula["python"].opt_bin}/python3",
           "-m", "mpi4py.run", "-m", "mpi4py.bench", "ringtest",
           "-l", "10", "-n", "1024"
  end
end
