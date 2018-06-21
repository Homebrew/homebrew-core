class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.15.0.tar.gz"
  sha256 "cab612708d861c488fbe216efc4f89fb026a386b2317867134d61104ac738e0a"
  revision 1
  head "https://github.com/planck-repl/planck.git"

  bottle do
    cellar :any
    sha256 "569707766f028f2efa37425d7f997d1bbd48b81a03c9f481a9d7e03fcf23bd67" => :high_sierra
    sha256 "2ceb73667de10494c1857fc44792d5119dcb9a791f2581c7d87541414a6b0354" => :sierra
    sha256 "356fb91f3a4acd991207229ddbc6aeb51a85ea56e262430d92cd74babf642b80" => :el_capitan
  end

  depends_on "clojure" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on :xcode => :build
  depends_on "libzip"
  depends_on "icu4c"
  depends_on :macos => :mavericks

  def install
    system "./script/build-sandbox"
    bin.install "planck-c/build/planck"
    bin.install "planck-sh/plk"
    man1.install Dir["planck-man/*.1"]
  end

  test do
    assert_equal "0", shell_output("#{bin}/planck -e '(- 1 1)'").chomp
  end
end
