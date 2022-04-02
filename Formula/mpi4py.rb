class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.github.io/"
  url "https://github.com/mpi4py/mpi4py/releases/download/3.1.3/mpi4py-3.1.3.tar.gz"
  sha256 "f1e9fae1079f43eafdd9f817cdb3fd30d709edc093b5d5dada57a461b2db3008"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_monterey: "9e0dc01ca3c56bd8307b84a344531150afdaa466f75579b57755d2a5e2a6dd5f"
    sha256 cellar: :any, arm64_big_sur:  "5e87a7ce5f7b2e702272c825e1ce772e66d1c9765524d38f8cb0c9650ca505e3"
    sha256 cellar: :any, monterey:       "8aad47e805537da4625fab7f300fb8be6e3ada89116c134c31e7bba07bfcc0f6"
    sha256 cellar: :any, big_sur:        "3e42d2f36fba22025e3c7c9a01096e4f79eb0872b449fb00ef0a1cf4a5c703a1"
    sha256 cellar: :any, catalina:       "f851c6383fabf7db02ed5570a4605d0b1bcb926f27be04ce2cda08b68c87ef4d"
    sha256               x86_64_linux:   "eef31e997cf6327384c7c9b861dfe7133c91448f30382c45cef0e8e1f4a31b21"
  end

  depends_on "libcython" => :build
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
