class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.github.io/"
  url "https://github.com/mpi4py/mpi4py/releases/download/3.1.3/mpi4py-3.1.3.tar.gz"
  sha256 "f1e9fae1079f43eafdd9f817cdb3fd30d709edc093b5d5dada57a461b2db3008"
  license "BSD-2-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "2450810fe0211f381bb0ef21509b36b9e5f2f39a11d66f40bfe8682d3f2a173a"
    sha256 cellar: :any, arm64_big_sur:  "6f18b4c0ee6f7442309cf2080d726e9f5304099a369b73bd0c707bf3052fd4c2"
    sha256 cellar: :any, monterey:       "ad2feec973870a61669dbdff6e12339221fea235d0c9b86d42ce8c208871a8c2"
    sha256 cellar: :any, big_sur:        "3b5d7c9bcf52b1f8372c73647cbbc08a6bedda23608aa90e64de509ba04d030a"
    sha256 cellar: :any, catalina:       "2b264bab7b5d9d1b1510ce4c1b32d5e121d3ada6a16ff876c95eb103250aa1d8"
    sha256               x86_64_linux:   "0e82afb7d7b13191157454c8913f09349609b52e2cf62be72537855af59da183"
  end

  depends_on "libcython" => :build
  depends_on "open-mpi"
  depends_on "python@3.10"

  def install
    system "python3", *Language::Python.setup_install_args(libexec),
                      "--install-lib=#{libexec/Language::Python.site_packages("python3")}"

    system "python3", "setup.py",
                      "build", "--mpicc=mpicc -shared", "--parallel=#{ENV.make_jobs}",
                      "install", "--prefix=#{prefix}",
                      "--single-version-externally-managed", "--record=installed.txt",
                      "--install-lib=#{prefix/Language::Python.site_packages("python3")}"
  end

  test do
    python = Formula["python@3.10"].opt_bin/"python3"

    system python, "-c", "import mpi4py"
    system python, "-c", "import mpi4py.MPI"
    system python, "-c", "import mpi4py.futures"

    system "mpiexec", "-n", ENV.make_jobs, "--use-hwthread-cpus",
           python, "-m", "mpi4py.run", "-m", "mpi4py.bench", "helloworld"
    system "mpiexec", "-n", ENV.make_jobs, "--use-hwthread-cpus",
           python, "-m", "mpi4py.run", "-m", "mpi4py.bench", "ringtest", "-l", "10", "-n", "1024"
  end
end
