class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/2.4.0.tar.gz"
  sha256 "e678d5e13867d5417011548c320a3e01fa4e3999c39a307f50e198cec1d7094e"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any
    sha256 "293bce0873a308586fec82b0dee53cd051cebe7e36b285661f4fc35c58140098" => :sierra
    sha256 "6642ce1866b61d13bccf05662c492e07f841f835aa69976fd3c0a5fe3e5f0662" => :el_capitan
    sha256 "01eaf82afa56e5cab36f0953ac03d7e13e8f5f9d5ba4c63efc2dfa35883d5334" => :yosemite
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
