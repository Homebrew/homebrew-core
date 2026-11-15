class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.github.io/"
  url "https://github.com/mpi4py/mpi4py/releases/download/4.1.2/mpi4py-4.1.2.tar.gz"
  sha256 "56860286dc45f20e8821e93cb06669e30462348bf866f685553fa4b712d58d02"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5eae24fbdbe6296f6312cdc6ea98b48efcc8c8debfaddb7372c51d39e87603e5"
    sha256 cellar: :any, arm64_tahoe:       "c7a78b2264a41ab9a25d2544a0c7885e23854d6ca35e66e91c4ca6f79eca11c7"
    sha256 cellar: :any, arm64_sequoia:     "fb53a0590092fc3ed90b1741bd9a319169a9be601342e0c2fb24dce74e3d9419"
    sha256               arm64_linux:       "f73e78d463cb85eaf75d44e875dc60ef2c3bf810f39fa238aeb510bce3a8e514"
    sha256               x86_64_linux:      "e1d52797ce0dd7029cc6f82c84f10707fda4577b9d0eb95d6460377830e011c9"
  end

  depends_on "open-mpi"
  depends_on "python@3.15"

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
