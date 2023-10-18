class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.github.io/"
  url "https://github.com/mpi4py/mpi4py/releases/download/3.1.5/mpi4py-3.1.5.tar.gz"
  sha256 "a706e76db9255135c2fb5d1ef54cb4f7b0e4ad9e33cbada7de27626205f2a153"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "384f50c2948a0ee3394cf55923e3b1d16e5e43405bddd7232f93e8b5dec20c88"
    sha256 cellar: :any, arm64_ventura:  "44951c7cfcdf29e3ab19a538a4b29eececfddc423e56f9691774b63a9ffc0283"
    sha256 cellar: :any, arm64_monterey: "608da0b1163e29267168ab334d6578f1dffe76e1305a2eb9562ab2c46c6548cf"
    sha256 cellar: :any, sonoma:         "b0d90ac0c85fb56bc7e6e6b9908237894c945cd01e6610f87cf9fcfd19e82cec"
    sha256 cellar: :any, ventura:        "4112b2e41b4624794c801112728f033ce205e66d9a3436222d23143f885021be"
    sha256 cellar: :any, monterey:       "2f4cfa512e19b5c261a13d3ff02270c05856717596a898e96f825716b9c7d308"
    sha256               x86_64_linux:   "e953370f964d4fcaa04248469b34d5001a5c617aa7187e044f97c5338b0fb1bf"
  end

  depends_on "libcython" => :build
  depends_on "open-mpi"
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    system python3, *Language::Python.setup_install_args(libexec, python3)

    system python3, "setup.py",
                    "build", "--mpicc=mpicc -shared", "--parallel=#{ENV.make_jobs}",
                    "install", "--prefix=#{prefix}",
                    "--single-version-externally-managed", "--record=installed.txt",
                    "--install-lib=#{prefix/Language::Python.site_packages(python3)}"
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
