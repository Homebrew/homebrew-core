class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.readthedocs.io"
  url "https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-3.1.1.tar.gz"
  sha256 "e11f8587a3b93bb24c8526addec664b586b965d83c0882b884c14dc3fd6b9f5c"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8b7ad2f636c83307d0e95c1e8810d81072354ca20c49726689fd09d053c671d0"
    sha256 cellar: :any, big_sur:       "b7ca05b0d8ddcc698e1ee29e6108f169cff4f4552ca80842469a63c0a6e90de1"
    sha256 cellar: :any, catalina:      "9019d4011822668326aec24352f2a743457e727d83d3903b1bee00a1bbfd6751"
    sha256 cellar: :any, mojave:        "19b22755d25aab224777f996e12cbcb16a8156f1bf98123a607d648b676d7af4"
    sha256               x86_64_linux:  "25b6d3d54394801fcbb646690cf145e0cae56c9aee9ed43da210c25f65cee914"
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
    python = Formula["python@3.9"].opt_bin/"python3"

    system python, "-c", "import mpi4py"
    system python, "-c", "import mpi4py.MPI"
    system python, "-c", "import mpi4py.futures"

    system "mpiexec", "-n", ENV.make_jobs, "--use-hwthread-cpus",
           python, "-m", "mpi4py.run", "-m", "mpi4py.bench", "helloworld"
    system "mpiexec", "-n", ENV.make_jobs, "--use-hwthread-cpus",
           python, "-m", "mpi4py.run", "-m", "mpi4py.bench", "ringtest", "-l", "10", "-n", "1024"
  end
end
