class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/2.12.0.tar.gz"
  sha256 "ccaed676a7847becc045c7491b47ab3e218ab7ed7fe937d222e3cda796ab25e3"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any
    sha256 "fc0e2755eb48e381584582b4745a6ae1c3f6867cd983c347d3e71d8b9f8a804e" => :high_sierra
    sha256 "ceed94b45e9d7b26ec894d4a6885ecba5b1025955b92147ad24502fcd21f2b8d" => :sierra
    sha256 "b27cfa074e782afa9abc4c91d56fb27c5fd3f30db195f941c896d520aed29cd2" => :el_capitan
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
  end

  test do
    assert_equal "0", shell_output("#{bin}/planck -e '(- 1 1)'").chomp
  end
end
