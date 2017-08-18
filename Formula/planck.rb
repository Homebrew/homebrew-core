class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/2.7.3.tar.gz"
  sha256 "16a620c33bc15c2f74ce1e80726c55c85f634443c9675c0c08292a964eb01780"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any
    sha256 "19a7cc443730c7d944a93d648cfe9b51f39217a74a7ab0fb93243f9a0d0c88ae" => :sierra
    sha256 "947c188b94b40e0cc23cc07066bc4c9cd4b69894f89312c3770baf2df79b0206" => :el_capitan
    sha256 "d2e1b047ef7a0de1f4763a8a18d11882be72cd56f5f3e75133d7b000acbfa3c9" => :yosemite
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
