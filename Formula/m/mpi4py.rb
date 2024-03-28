class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.github.io/"
  url "https://github.com/mpi4py/mpi4py/releases/download/3.1.5/mpi4py-3.1.5.tar.gz"
  sha256 "a706e76db9255135c2fb5d1ef54cb4f7b0e4ad9e33cbada7de27626205f2a153"
  license "BSD-2-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sonoma:   "17f84b39f8d35ba4ed6922d604e599769a211690d6f1a25d185ed415af1ab524"
    sha256 cellar: :any, arm64_ventura:  "131d931b6f5bb7a56fc04da4308efdca7415fc370c1f98efbb4ba0fc4742359f"
    sha256 cellar: :any, arm64_monterey: "3705c65aa4f31e42af91c04233811e22a7823dc72f75735889f2a5a254438de3"
    sha256 cellar: :any, sonoma:         "5419bda7e546158301027a7e95be0bffe62d1f8bd0bcdcb1c028600342e189c8"
    sha256 cellar: :any, ventura:        "0f8b048146a510c545ec1c5b6563d348f1dfeaf4fdf7314a41efa7a171056bc7"
    sha256 cellar: :any, monterey:       "a955b0e4e4379e2884f75954093675e17f8001ae2bcf2c0ee7fc0f6d7f1e9e09"
    sha256               x86_64_linux:   "bf9015e5340ba63c8053f3266a9ead0f984723c9df9dc6a37dfed19b8cdd99d7"
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
