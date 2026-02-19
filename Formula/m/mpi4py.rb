class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.github.io/"
  url "https://github.com/mpi4py/mpi4py/releases/download/4.1.1/mpi4py-4.1.1.tar.gz"
  sha256 "eb2c8489bdbc47fdc6b26ca7576e927a11b070b6de196a443132766b3d0a2a22"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "90e4d286c7363f44451bef72bf75eb139d55454c35bb240eaf37d49c6649ab0d"
    sha256 cellar: :any, arm64_sequoia: "efcb605cb7760bdee4873a0c3240e54add78210f1c3282c63a61e0aeb94ea753"
    sha256 cellar: :any, arm64_sonoma:  "19caf71acbf7f93452f674b1aec4f62144246d4c5cbd5d5d4cbf7e11a7243b2d"
    sha256 cellar: :any, sonoma:        "6fe3a1ea44cc66cd2ab36531d66848f9f0e363591b14c272864d914c1e9422ba"
    sha256               arm64_linux:   "badce9774ee0885b972ce95082c2dc904d8f7113baae29231a09a884cabbcad2"
    sha256               x86_64_linux:  "749d4547c856b8cb35bd70869b15deffef02f4e42f9915792715da5338b3deb8"
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
