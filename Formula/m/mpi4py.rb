class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.github.io/"
  url "https://github.com/mpi4py/mpi4py/releases/download/3.1.6/mpi4py-3.1.6.tar.gz"
  sha256 "c8fa625e0f92b082ef955bfb52f19fa6691d29273d7d71135d295aa143dee6cb"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "55bdbc162a7ceb14f72116a1cb888da9e06419532905e3ec3f222d011a5e21d7"
    sha256 cellar: :any, arm64_ventura:  "46ca1e36c3f428433dd59b0093f8f0022686072a08b46b46dafae75a2f66e525"
    sha256 cellar: :any, arm64_monterey: "7c6b8ab027983c122adf9c77adb2deed5f65bf337819ee3ec148c9421bf4a994"
    sha256 cellar: :any, sonoma:         "b6ec53adbcfc129bae8da46aaa824302ef50039572e72094f3e45155ffe6f68a"
    sha256 cellar: :any, ventura:        "b0fdcb05a9b0b50f1de20d6c2e3a600847001db5941e69a57459bd6a44d636d2"
    sha256 cellar: :any, monterey:       "847b9e2f39508f08a24f5c2f7d6c3638710e7b0a1611756d46911e797b474447"
    sha256               x86_64_linux:   "989d1c12db3d151c9bc98be42be1f974e75859d7916f4da2de9f11f81ca67c40"
  end

  depends_on "open-mpi"
  depends_on "python@3.12"

  def python3
    "python3.12"
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
