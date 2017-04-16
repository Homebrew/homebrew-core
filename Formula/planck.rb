class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/2.2.0.tar.gz"
  sha256 "99d37253de53df25260c41db95cc65ee39a4209690c3814a1c5693a3cdf0c9cc"
  revision 1
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any
    sha256 "b4318ff7cbcd7fd34087636db868c75ebcb3bdab1fd0788c4db4426963ff994e" => :sierra
    sha256 "16350f5db666611250cd98507314567af706f1f031f5e8e24320233865184414" => :el_capitan
    sha256 "5e726041cd50428c818b69d4ad03c5fa78c37ac515a0ea07aefa9899c0b7d84c" => :yosemite
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
