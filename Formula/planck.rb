class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.20.0.tar.gz"
  sha256 "9d982024ac8db3ecc2771c6d0ba0c572143785e8eff9a0a6a7129bb0e41e96c7"
  head "https://github.com/planck-repl/planck.git"

  bottle do
    cellar :any
    sha256 "eabb90e5ef6d0fbb74df0dd4cfc5160751ed1cef85e09a68dace21dde9e268e4" => :mojave
    sha256 "a337e3c890f99a82723409f1c52f2bf3b83b77bf5a910e75f80e9cb93b39ccc6" => :high_sierra
    sha256 "258f24567d4c5a791a0162c3536de69c52eab990362c704ec9497290a9240776" => :sierra
  end

  depends_on "clojure" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on :xcode => :build
  depends_on "icu4c"
  depends_on "libzip"

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
