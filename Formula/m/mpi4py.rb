class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.github.io/"
  url "https://github.com/mpi4py/mpi4py/releases/download/4.1.1/mpi4py-4.1.1.tar.gz"
  sha256 "eb2c8489bdbc47fdc6b26ca7576e927a11b070b6de196a443132766b3d0a2a22"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b9eeb8c24989480fd139243a3bcb36b97bd4b60f214606ed2df83fad31980418"
    sha256 cellar: :any, arm64_sequoia: "500955463e604c6d475fa55579140e1b8ac12a4cc620abe41b701df31f90bcc9"
    sha256 cellar: :any, arm64_sonoma:  "652968b66f7a1c24729682d6c2a7e5108a2180a58609644daba4bcd347075512"
    sha256 cellar: :any, sonoma:        "7ec983abf82540632443040173ec98709464999b9d183057705b85eb8727fe99"
    sha256               arm64_linux:   "c9ee1abec879cf6b68b6d8265e8f1ab1b0bf41991b8e1cf4488950a0fc777a05"
    sha256               x86_64_linux:  "4e6462f70e3a29ce0d389ce921962f50543506f771bf17db8e3dc77010c5d83d"
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
