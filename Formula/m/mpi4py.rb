class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.github.io/"
  url "https://github.com/mpi4py/mpi4py/releases/download/4.1.2/mpi4py-4.1.2.tar.gz"
  sha256 "56860286dc45f20e8821e93cb06669e30462348bf866f685553fa4b712d58d02"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "98e0476debc8eaa858fe59a34330abf1308ecdd81af4bf5a4e9597b820d32712"
    sha256 cellar: :any, arm64_sequoia: "1cc66fbd269b6a883b4c1d7b36833406493e0a261b37e1484ec31669f80f7e1f"
    sha256 cellar: :any, arm64_sonoma:  "26805ba8070471c1f9faee42bd4c002ce22f5e7cfd72566b00afb163d16d3e33"
    sha256 cellar: :any, sonoma:        "09973bc8c8d2173845c3ffb363b683672a0deaacc15fffe92cfc6fc4c46a7675"
    sha256               arm64_linux:   "c50add57f3cafdda8c8ee9068b9ec0e227caa98fd01ad51e62a72bc1d9541851"
    sha256               x86_64_linux:  "df3fa9350772f338d7fcd2bfda087e9a6d1392ab2c4d80bddee99653a5b40813"
  end

  depends_on "open-mpi"
  depends_on "python@3.14"

  def python3
    "python3.14"
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
