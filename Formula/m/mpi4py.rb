class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.github.io/"
  url "https://github.com/mpi4py/mpi4py/releases/download/4.1.0/mpi4py-4.1.0.tar.gz"
  sha256 "817492796bce771ccd809a6051cf68d48689815493b567a696ce7679260449cd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "61a98a4cb90a3a16484e15c427afb8f98401ce4d6a5b4f40fdc419cb219799e7"
    sha256 cellar: :any, arm64_sonoma:  "92a9daced60284a5d9cd9969719d3a29c2014d794b1cc2c9f40ed5cdf1cc2006"
    sha256 cellar: :any, arm64_ventura: "761063a583be9a8f05e2fa7dc63c8ebac069785dbd5e968ebd161ed449132b18"
    sha256 cellar: :any, sonoma:        "c8d291f48a76502621409a808db8a74492a4e3ebf66cd39402fabd550da912cb"
    sha256 cellar: :any, ventura:       "2d8eacea786cc0bc99690dfece29172c435c92fd4dbc621d6a296881bd9a9610"
    sha256               arm64_linux:   "3c4bbc35ab042230c0371df833fc924512ceadb2b315bf192b4b47c5dd78fc76"
    sha256               x86_64_linux:  "b7a29ffe65f402fb6040a6a000fb43b8ead0826b8d0426f62a8f48779cefd8af"
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
