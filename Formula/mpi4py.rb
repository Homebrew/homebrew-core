class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.github.io/"
  url "https://github.com/mpi4py/mpi4py/releases/download/3.1.4/mpi4py-3.1.4.tar.gz"
  sha256 "17858f2ebc623220d0120d1fa8d428d033dde749c4bc35b33d81a66ad7f93480"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_monterey: "0169208c525eb3e6a9a10c63b84be3458f9969adc69bd4ae0d415ac50e1cef64"
    sha256 cellar: :any, arm64_big_sur:  "e440d9fca861514468b9b87bb9d03e67f6b428af606e5ef64e447a3399d84e03"
    sha256 cellar: :any, monterey:       "1070a8e7d616c5d58608669ac32acbba57cdd3a5e569f0ba83077f66f0acdd8b"
    sha256 cellar: :any, big_sur:        "2d9d12508b1e29e9a99ea00ed527c284e4dfa85cb7d57f439f834f7e7d0b398b"
    sha256 cellar: :any, catalina:       "38b300a64c142dc41cd1341f722c6aa5a4584a326b999d9b06ace03ce2966680"
    sha256               x86_64_linux:   "379619980a4feff8c6e841ce13466f4f120be82d90fd5ba5f454e8ae9ed4358a"
  end

  depends_on "libcython" => :build
  depends_on "open-mpi"
  depends_on "python@3.10"

  def python3
    "python3.10"
  end

  def install
    system python3, *Language::Python.setup_install_args(libexec, python3)

    system python3, "setup.py",
                    "build", "--mpicc=mpicc -shared", "--parallel=#{ENV.make_jobs}",
                    "install", "--prefix=#{prefix}",
                    "--single-version-externally-managed", "--record=installed.txt",
                    "--install-lib=#{prefix/Language::Python.site_packages(python3)}"
  end

  test do
    python = Formula["python@3.10"].opt_bin/python3

    system python, "-c", "import mpi4py"
    system python, "-c", "import mpi4py.MPI"
    system python, "-c", "import mpi4py.futures"

    system "mpiexec", "-n", ENV.make_jobs, "--use-hwthread-cpus",
           python, "-m", "mpi4py.run", "-m", "mpi4py.bench", "helloworld"
    system "mpiexec", "-n", ENV.make_jobs, "--use-hwthread-cpus",
           python, "-m", "mpi4py.run", "-m", "mpi4py.bench", "ringtest", "-l", "10", "-n", "1024"
  end
end
