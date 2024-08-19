class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.github.io/"
  url "https://github.com/mpi4py/mpi4py/releases/download/4.0.0/mpi4py-4.0.0.tar.gz"
  sha256 "820d31ae184d69c17d9b5d55b1d524d56be47d2e6cb318ea4f3e7007feff2ccc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "af0b502535e60fc352f583f6dc3e6f22656d51b2b8a6879e286d5746eadbaeaf"
    sha256 cellar: :any, arm64_ventura:  "3f8f8cd4ab3bf101d205bd7750a0ba506b44f19e4d4a0a77165e9cf3ad485cca"
    sha256 cellar: :any, arm64_monterey: "e5db582124c03962a6b713df7f224d0c39860e61d60ee8d7bbe3b09fd7a58648"
    sha256 cellar: :any, sonoma:         "623f199ac2973c68186eccba9126fc3c9845bd2ca5f28eeba2da167df66d745e"
    sha256 cellar: :any, ventura:        "b4f16e256a6eae84ce6ba36302267080010e9d03ea6bc84098ac19652a0388f9"
    sha256 cellar: :any, monterey:       "406ac34f87b65a4227b974a1b5f39d20f499a5783900618d6253c206cb051658"
    sha256               x86_64_linux:   "75879be194af8dc54e5a70960f0fef8e289e10482f85f377e4e298eacd7f6c51"
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
