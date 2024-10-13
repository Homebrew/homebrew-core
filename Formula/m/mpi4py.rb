class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.github.io/"
  url "https://github.com/mpi4py/mpi4py/releases/download/4.0.1/mpi4py-4.0.1.tar.gz"
  sha256 "f3174b245775d556f4fddb32519a2066ef0592edc810c5b5a59238f9a0a40c89"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "557a93e747f7b13041f6104ecb537616e6d6080bc485e6964d8b6ab7699e7af1"
    sha256 cellar: :any, arm64_sonoma:  "2d6bba0738377bf1c10bf44a51de01c4fe125f25ff30277a85150f7c62f1932f"
    sha256 cellar: :any, arm64_ventura: "6087645f1f222cd2a5efe80274895f5da76190f7fdae53c19a41442a4ea26372"
    sha256 cellar: :any, sonoma:        "c6df8310a13fdf5f75d7d3dac7e5696d643fcdb487182185d77fcc3aaa897138"
    sha256 cellar: :any, ventura:       "8a5f05db2cc8ddf8dd771a04001b324e1d148610f7cf18134cfb08dd9fc72a07"
    sha256               x86_64_linux:  "d5850a6a3d6c4cc24c46f1d6054c71aaa1773f377b6887794761d2eca9467a96"
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
