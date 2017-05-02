class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/2.3.0.tar.gz"
  sha256 "7a84c0e3ab672624b9e5bf4b98821e7fa5bb4882fd5c0faf02c120a9a3a86a94"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any
    sha256 "46fe0421ff1b8f935452a1635b3021c6d345a1a06ca16343faf9450c715415d1" => :sierra
    sha256 "b611b552f4945adcb45ee0641ab66064e96073ac12b583205fe7fcc0c5fcd9c1" => :el_capitan
    sha256 "9e192fc4c4d04387568beffb4728fbf3805e8755eeab47e16f09bbc49b8b6865" => :yosemite
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
