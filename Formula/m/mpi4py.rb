class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.github.io/"
  url "https://github.com/mpi4py/mpi4py/releases/download/3.1.4/mpi4py-3.1.4.tar.gz"
  sha256 "17858f2ebc623220d0120d1fa8d428d033dde749c4bc35b33d81a66ad7f93480"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_ventura:  "b30806b3afe2be3c9e592c2064e812a1bdcf8662ab99aa7430e4193bd07c144b"
    sha256 cellar: :any, arm64_monterey: "4583823ac899d99e53091846606a60b533e2fa714a6b14c0b782b77df41ef0bb"
    sha256 cellar: :any, arm64_big_sur:  "0fe1dc462308e559acab6f9f6be17eb8281db02f3ea215dd2e3f3563416363be"
    sha256 cellar: :any, ventura:        "bc6e01f2b0ea8fb52d03fc9709f40aa3d3dfd709ebbbd777253799fceb398c12"
    sha256 cellar: :any, monterey:       "99ed2832a24166cfa1b07730265a0d2bd381d94008ecbbf518a19aa6d8770724"
    sha256 cellar: :any, big_sur:        "f53ed4d49183522ed690a93b6ea43977fa4d12a7b510334ede16bc9eda3ec69f"
    sha256 cellar: :any, catalina:       "df0baae9ef9c3052d98771b25759485949ce6f94757b33e1b55ffd2c36f115dd"
    sha256               x86_64_linux:   "781835f0d3ca64ffbd4f3344ea1e428c3dce993f749268ed5f232b87a2c84434"
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
