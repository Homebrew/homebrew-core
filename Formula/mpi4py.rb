class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.readthedocs.io"
  url "https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-3.0.3.tar.gz"
  sha256 "012d716c8b9ed1e513fcc4b18e5af16a8791f51e6d1716baccf988ad355c5a1f"
  revision 1

  bottle do
    cellar :any
    sha256 "f32637afaa7a9e9b1de6db1df8707faa1bf3b82f9184f1d4415154c80907fa2d" => :catalina
    sha256 "0722fb13f9b85970dbdd113d4616ea7c47ea69fdc89747c51fa882adc1fe62d4" => :mojave
    sha256 "f8cb782c83655a5a97f0016bd519a6528d9f6b73fe61ccd8420f33d4b9a34155" => :high_sierra
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
