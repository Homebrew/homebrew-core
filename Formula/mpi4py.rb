class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.readthedocs.io"
  url "https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-3.0.3.tar.gz"
  sha256 "012d716c8b9ed1e513fcc4b18e5af16a8791f51e6d1716baccf988ad355c5a1f"

  bottle do
    cellar :any
    sha256 "e4b9bf0d251aa9c6a23e39eee7fdc476e985734a84ff6228aaddea4e87a10f34" => :catalina
    sha256 "aab2b09949a0f4984c1ea8969d98f33cada88f23a02e8b6661d616cd641579c9" => :mojave
    sha256 "c4386874ab89d58514fcabbdf2dd912f7a3f1d5d1d4b3a23487f60b03ee6489d" => :high_sierra
  end

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
