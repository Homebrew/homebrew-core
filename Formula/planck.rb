class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/planck-repl/planck/archive/2.13.0.tar.gz"
  sha256 "aa1e67e90dca742061de725f30492ecc4287e73486aca5a684fdc602a86d7c0e"
  head "https://github.com/planck-repl/planck.git"

  bottle do
    cellar :any
    sha256 "567277d275232b81c49cd3cd9af3ca49c367a1f4d8c6df0db717da7c9239e094" => :high_sierra
    sha256 "ba7f398b53b9a5677c1bb2ee0bd30343eec1d010cbe9ad69070fb01567efe6f8" => :sierra
    sha256 "2f4c4267baab304d8ae11e46b0dcd23f0f5acd55f11ed2b1f14df8a72a49dbee" => :el_capitan
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
    bin.install "planck-sh/plk"
  end

  test do
    assert_equal "0", shell_output("#{bin}/planck -e '(- 1 1)'").chomp
  end
end
