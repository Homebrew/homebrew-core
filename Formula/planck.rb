class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "https://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.25.0.tar.gz"
  sha256 "58a3f9b0e3d776bc4e28f1e78a8ce6ab1d98149bebeb5c5328cc14345b925a1f"
  license "EPL-1.0"
  revision 2
  head "https://github.com/planck-repl/planck.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "ae9c4d505e495c03e50facc262a0c2a4cc924707aadd380d68e72c828f8707b3"
    sha256 cellar: :any, arm64_big_sur:  "d8a3539294b4ba931761adad175e84404a95dd991f977501f89c19e533fff9a2"
    sha256 cellar: :any, monterey:       "85198ae6acebb93fe6fc8c7f0d00911e8e3806eb06fbb73101ac712f1d9ebac1"
    sha256 cellar: :any, big_sur:        "436bb7f0481e0a6a0edeaa1abd2687c349e6314bf6139a2b8ae4e9a73978ed8e"
    sha256 cellar: :any, catalina:       "2528a360ad99d9d5031ae53138523c691e5a5ccb93da15cc44d214a9ad0d2e3b"
    sha256 cellar: :any, mojave:         "b0d1fe14b9ab71a5a18601e8e21fe3b16dc96247b877ce6842bbc7c7cae93784"
  end

  depends_on "clojure" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build
  depends_on "icu4c"
  depends_on "libzip"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    system "./script/build-sandbox"
    bin.install "planck-c/build/planck"
    bin.install "planck-sh/plk"
    man1.install Dir["planck-man/*.1"]
  end

  test do
    assert_equal "0", shell_output("#{bin}/planck -e '(- 1 1)'").chomp
  end
end
