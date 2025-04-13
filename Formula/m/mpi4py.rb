class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.github.io/"
  url "https://github.com/mpi4py/mpi4py/releases/download/4.0.3/mpi4py-4.0.3.tar.gz"
  sha256 "de2710d73e25e115865a3ab63d34a54b2d8608b724f761c567b6ad58dd475609"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "0501e4b0090b389f28bf811e030cce459046822bb64e071f94d5c74964e84d26"
    sha256 cellar: :any, arm64_sonoma:  "b393c5ebd793e9e199cc2681d75a7eb88d2b76dded65415ba5f8f90cc340c24f"
    sha256 cellar: :any, arm64_ventura: "c6eed01d56ba9ea0428fb4e1642841f0a1c5dfb557ef35ed6b4cd1ed8b4d31b4"
    sha256 cellar: :any, sonoma:        "744208f4b105609b87741f35086ea216e1398b4c6c09d9fb787bd4d22325f549"
    sha256 cellar: :any, ventura:       "299052d6163ebd6bec99ed7f6bf45335ac789b8997ebf6ddaf17d230f6cce39e"
    sha256               arm64_linux:   "7946ccf43c5b2b2c847aacd671197ab0cc490c809cd430650f464b9c2f16fe7f"
    sha256               x86_64_linux:  "3f62e99678a4742ac5f2fa8abcce5cead52a9c1bc884993e6547e063aea672a3"
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
