class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/2.6.0.tar.gz"
  sha256 "35de8a63b41c7a940a1f3b2a5d6ca90865c7b7ec21d5b355da3fc1c704f70f41"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any
    sha256 "8855877e3cea8aaf987e35af27d7a767f87cbab75d74bdfc531bdee970ae13c4" => :sierra
    sha256 "4de5d7fae500c7328619118b84ce40522fe6c8d02dabea827ea4a06d6087a8c0" => :el_capitan
    sha256 "a81cd9f17b86967c6cd8d1d7504afe9ee21f5d3825dde67ab85a5c4615453a5c" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "leiningen" => :build
  depends_on :xcode => :build
  depends_on "libzip"
  depends_on "icu4c"
  depends_on :macos => :mavericks

  def install
    system "./script/build-sandbox"
    bin.install "planck-c/build/planck"
  end

  test do
    assert_equal "0", shell_output("#{bin}/planck -e '(- 1 1)'").chomp
  end
end
