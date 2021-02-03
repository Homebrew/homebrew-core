class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.readthedocs.io"
  url "https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-3.0.3.tar.gz"
  sha256 "012d716c8b9ed1e513fcc4b18e5af16a8791f51e6d1716baccf988ad355c5a1f"
  revision 2

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0f4729ca14721e02e752fa831f91c0463d32163e86c7097896843c553d0b8f30"
    sha256 cellar: :any, big_sur:       "3b761d6032292468252ff3c8aa01c61f4e71cf945235a88e18eebd97d9bfd957"
    sha256 cellar: :any, catalina:      "c6163dd690053dc5adcca25c63c54c5feb34d46248685e3d448ef673e907de36"
    sha256 cellar: :any, mojave:        "e3bec47030124ee25c7d8d0bc31f24f6c317e81da4878e008ae8bb4cb26fb017"
    sha256 cellar: :any, high_sierra:   "3c73ed25e9e29e5232bfe258147ebe87dd78ae5d295d4de6a1ec4f93475635a6"
  end

  depends_on "cython" => :build
  depends_on "open-mpi"
  depends_on "python@3.9"

  def install
    system "#{Formula["python@3.9"].opt_bin}/python3",
           *Language::Python.setup_install_args(libexec)

    system Formula["python@3.9"].bin/"python3", "setup.py",
      "build", "--mpicc=mpicc -shared", "--parallel=#{ENV.make_jobs}",
      "install", "--prefix=#{prefix}",
      "--single-version-externally-managed", "--record=installed.txt"
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3",
           "-c", "import mpi4py"
    system Formula["python@3.9"].opt_bin/"python3",
           "-c", "import mpi4py.MPI"
    system Formula["python@3.9"].opt_bin/"python3",
           "-c", "import mpi4py.futures"
    system "mpiexec", "-n", "4", Formula["python@3.9"].opt_bin/"python3",
           "-m", "mpi4py.run", "-m", "mpi4py.bench", "helloworld"
    system "mpiexec", "-n", "4", Formula["python@3.9"].opt_bin/"python3",
           "-m", "mpi4py.run", "-m", "mpi4py.bench", "ringtest",
           "-l", "10", "-n", "1024"
  end
end
