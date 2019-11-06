class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "https://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.24.0.tar.gz"
  sha256 "b4b1b36786fd55be829a6b0a42771d9134152b503dafa92ee0f2c6e57c8cb3ca"
  head "https://github.com/planck-repl/planck.git"

  bottle do
    cellar :any
    sha256 "3177fd16d273dd4c83a707f84ef53fc54b798be34c7ad0db0853239595c3f665" => :catalina
    sha256 "ebc05c0fca4a5c7c709a5cfc0c74fc204879cee084725e0817c8e9fdbcbb37f4" => :mojave
    sha256 "b1592c991ae76dafbad080bdebd73607c15fd104b6c01094dc685719d3dd71ca" => :high_sierra
    sha256 "143c12e2d4fab26e682ef5c62fa72074a37f8ba8e0f6b0c177e3aa35083c9fcc" => :sierra
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
