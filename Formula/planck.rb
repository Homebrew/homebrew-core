class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/2.1.0.tar.gz"
  sha256 "cfd9906c47ae2764aface3e70d06e2db14d67f7caaf4571f24e389b5618c1633"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any
    sha256 "6833f15a0b7256f8b3fc7b50f5b9a555d3fa572c6a782e600faf15cbd778a78a" => :sierra
    sha256 "b7087b27513414d3b8ac5b6d496a6b2d8d65226c9351b56aacc8d2ec39127d25" => :el_capitan
    sha256 "29dbe06e1a4cbb75e0a27be15a19a09a8ebfba602edf038dd83874d408b11840" => :yosemite
  end

  depends_on "libzip"
  depends_on "icu4c"
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "leiningen" => :build
  depends_on :xcode => :build
  depends_on :macos => :mavericks

  def install
    system "./script/build-sandbox"
    bin.install "planck-c/build/planck"
  end

  test do
    assert_equal "0", shell_output("#{bin}/planck -e '(- 1 1)'").chomp
  end
end
