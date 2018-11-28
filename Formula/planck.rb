class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.19.0.tar.gz"
  sha256 "bb33984f986a7ac68b331cfd64bd0f9e41daf5391b1a36e158e15d94d886dd04"
  revision 1
  head "https://github.com/planck-repl/planck.git"

  bottle do
    cellar :any
    sha256 "e7b584c5ace1a2a3e18d3c6a01b7c2bd66e9f4ccae66a373bdf4f8a55dbab4d2" => :mojave
    sha256 "f58b0a6f85d2a2ab05721ced6b038342bfed3d0b012a85e58a517a149cb649c1" => :high_sierra
    sha256 "f8a5a0ad3cd40ae5d54643704cc923a9a153ab2b37d2628739097df3c2731033" => :sierra
  end

  depends_on "clojure" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on :xcode => :build
  depends_on "icu4c"
  depends_on "libzip"
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
