class Bastet < Formula
  desc "Bastard Tetris"
  homepage "https://fph.altervista.org/prog/bastet.html"
  url "https://github.com/fph/bastet/archive/refs/tags/0.43.2.tar.gz"
  sha256 "f219510afc1d83e4651fbffd5921b1e0b926d5311da4f8fa7df103dc7f2c403f"
  license "GPL-3.0-or-later"
  revision 8

  bottle do
    sha256 arm64_sonoma:   "613188cf7249352d19dc221c665e284cbe2c1cb23e1f1660839443ccc9b3590a"
    sha256 arm64_ventura:  "4796e71682caa79b26c8ac9f08efb98b3b4d93ce06b85a87d8b4e32caec83e87"
    sha256 arm64_monterey: "c1914a121bce507894647f9107dfe71c2dcb861fcf30a5be6cc873eb7c1cf895"
    sha256 sonoma:         "1e74837a564737a04ab9620ab01e453f5329c1c2131fd49b0cec73ecd0dbeefa"
    sha256 ventura:        "9355ece1db630ee9a17ec079e8a927b57b072375e284079f131da8f43bcb3b15"
    sha256 monterey:       "f351b34012eb18c94adb76f1feb7dce7e65875288a8db08fd90171c962105589"
    sha256 x86_64_linux:   "c37884c0f7cb692d4afe307a3197b8df7a142936578043b62444c50e02e5a794"
  end

  depends_on "boost"
  uses_from_macos "ncurses"

  # Fix compilation with Boost >= 1.65, remove for next release
  patch do
    url "https://github.com/fph/bastet/commit/0e03f8d4.patch?full_index=1"
    sha256 "9b937d070a4faf150f60f82ace790c7a1119cff0685b52edf579740d2c415d7b"
  end

  def install
    inreplace %w[Config.cpp bastet.6], "/var", var

    ENV.append "CXXFLAGS", "-std=c++14"

    system "make", "all"

    # this must exist for games to be saved globally
    (var/"games").mkpath
    touch "#{var}/games/bastet.scores2"

    bin.install "bastet"
    man6.install "bastet.6"
  end

  test do
    pid = fork do
      exec bin/"bastet"
    end
    sleep 3

    assert_predicate bin/"bastet", :exist?
    assert_predicate bin/"bastet", :executable?
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
