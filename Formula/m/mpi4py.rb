class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.github.io/"
  url "https://github.com/mpi4py/mpi4py/releases/download/4.0.2/mpi4py-4.0.2.tar.gz"
  sha256 "86085436d3ea3587323321b9e661e4df60eabbcf11c2c9cf63d0873ca111cc8b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "32b13cb8042f4dfd37c78d79d3da903f5712c0ec72a5952363a335082a122d6e"
    sha256 cellar: :any, arm64_sonoma:  "cd6dc1fff8fe5bc4337a6c313121fb2e04fa6a2a8810be2a60947ee01b27ba4b"
    sha256 cellar: :any, arm64_ventura: "43500fc00e49b1f3f76075204030a9c38ae69255cdb37bce78fc341df7c073e3"
    sha256 cellar: :any, sonoma:        "32de80ff73af6932495888ddaa2438428bda00196b20a0d075ede3efdda1fd2b"
    sha256 cellar: :any, ventura:       "0415eb8c513d25c5945162faa56bc058bccc5a0bac8b89db85114308647738eb"
    sha256               x86_64_linux:  "af43aac69a4bc89a335a58912d5fb54d141db3f76952977092ac3c16258987cb"
  end

  depends_on "open-mpi"
  depends_on "python@3.13"

  def python3
    "python3.13"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
  end

  test do
    system python3, "-c", "import mpi4py"
    system python3, "-c", "import mpi4py.MPI"
    system python3, "-c", "import mpi4py.futures"

    system "mpiexec", "-n", ENV.make_jobs, "--use-hwthread-cpus",
           python3, "-m", "mpi4py.run", "-m", "mpi4py.bench", "helloworld"
    system "mpiexec", "-n", ENV.make_jobs, "--use-hwthread-cpus",
           python3, "-m", "mpi4py.run", "-m", "mpi4py.bench", "ringtest", "-l", "10", "-n", "1024"
  end
end
