class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.readthedocs.io"
  url "https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-3.0.3.tar.gz"
  sha256 "012d716c8b9ed1e513fcc4b18e5af16a8791f51e6d1716baccf988ad355c5a1f"
  revision 1

  bottle do
    cellar :any
    sha256 "c7986ad3dd30dad9ec0e39d0bb8a6b393e83928602911cce0c8ba9fa754f573d" => :catalina
    sha256 "6ab550d9030af6de7be420e8c09789f39b378850206c6bdac92ee34507418688" => :mojave
    sha256 "a7240ca7705037a69127ae6337274e2f4fdf4675897195199d63339d12011d1b" => :high_sierra
  end

  depends_on "cython" => :build
  depends_on "open-mpi"
  depends_on "python@3.8"

  def install
    system "#{Formula["python@3.8"].opt_bin}/python3",
           *Language::Python.setup_install_args(libexec)

    system Formula["python@3.8"].bin/"python3", "setup.py",
      "build", "--mpicc=mpicc -shared", "--parallel=#{ENV.make_jobs}",
      "install", "--prefix=#{prefix}",
      "--single-version-externally-managed", "--record=installed.txt"
  end

  test do
    system Formula["python@3.8"].opt_bin/"python3",
           "-c", "import mpi4py"
    system Formula["python@3.8"].opt_bin/"python3",
           "-c", "import mpi4py.MPI"
    system Formula["python@3.8"].opt_bin/"python3",
           "-c", "import mpi4py.futures"
    system "mpiexec", "-n", "4", Formula["python@3.8"].opt_bin/"python3",
           "-m", "mpi4py.run", "-m", "mpi4py.bench", "helloworld"
    system "mpiexec", "-n", "4", Formula["python@3.8"].opt_bin/"python3",
           "-m", "mpi4py.run", "-m", "mpi4py.bench", "ringtest",
           "-l", "10", "-n", "1024"
  end
end
