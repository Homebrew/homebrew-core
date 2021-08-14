class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.readthedocs.io"
  url "https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-3.1.1.tar.gz"
  sha256 "e11f8587a3b93bb24c8526addec664b586b965d83c0882b884c14dc3fd6b9f5c"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f826004fe6522e3eb1b839a150f1e568b17c0ee121bd790b5d7f3e824eab34ad"
    sha256 cellar: :any, big_sur:       "0504f3a4ba92bba6d776b6328bf21a04d319421b0b15d531f6d01eb62cf3d57b"
    sha256 cellar: :any, catalina:      "82793e2826ec25f36758488071071383f963928acfccb3661cbd8e702de34529"
    sha256 cellar: :any, mojave:        "b51dac4f1d8b24d10de17c13728ef0c61ff28ac17340570c715dce74cb2ca221"
    sha256               x86_64_linux:  "c000d6591c02d4b6b155c55343c2c5a9d37ce2f19ba19e657e1c924de1959390"
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

    system "mpiexec", "-n", ENV.make_jobs,
           python, "-m", "mpi4py.run", "-m", "mpi4py.bench", "helloworld"
    system "mpiexec", "-n", ENV.make_jobs,
           python, "-m", "mpi4py.run", "-m", "mpi4py.bench", "ringtest", "-l", "10", "-n", "1024"
  end
end
