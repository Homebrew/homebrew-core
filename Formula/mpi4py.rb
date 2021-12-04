class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.readthedocs.io"
  url "https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-3.1.3.tar.gz"
  sha256 "f1e9fae1079f43eafdd9f817cdb3fd30d709edc093b5d5dada57a461b2db3008"

  bottle do
    sha256 cellar: :any, arm64_monterey: "350da7c76c749159e384b65271a7107f5a11f50551d24af50cc12a74f4f435c4"
    sha256 cellar: :any, arm64_big_sur:  "ffd1fb9532eb300ce207ee90f9639adb66d6a92c04ae858f3e4833f8e45c5e80"
    sha256 cellar: :any, monterey:       "840c485c2cd77c090e6357e01de11e7d978e07e3af532fd3443616e3c69e595c"
    sha256 cellar: :any, big_sur:        "373301a51fae0801ddd32dfb31bb78efc33aa2e137440f7cab9968686839cd4b"
    sha256 cellar: :any, catalina:       "16bd58266cfa05fc6702543dcb39b0a5eba2795db2b01cb3cc5c8ff9186bd2e3"
    sha256               x86_64_linux:   "8e464b664c635e1a446fa24a0167d1b9bbf97ebfcb0cfe692b0b4bd7d21f145e"
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
