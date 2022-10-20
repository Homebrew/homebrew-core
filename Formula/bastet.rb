class Bastet < Formula
  desc "Bastard Tetris"
  homepage "https://fph.altervista.org/prog/bastet.html"
  url "https://github.com/fph/bastet/archive/0.43.2.tar.gz"
  sha256 "f219510afc1d83e4651fbffd5921b1e0b926d5311da4f8fa7df103dc7f2c403f"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 arm64_monterey: "847549943397d6599052de7fddb1028fa521e86c778bb32ecc876b597d352c2e"
    sha256 arm64_big_sur:  "f4e46f9ceeb65880d581bf0db249e4b781c37abadbd3d3199ff66aafde2f28d4"
    sha256 monterey:       "c003bbb534a90d60b8a48abb3fc4fc418d5efe51f334063e5082b090dfc589cf"
    sha256 big_sur:        "1309388b45599252aff6a86e11c634ce1eaf432ba95048af329c9c31103362ef"
    sha256 catalina:       "afea0c4b2b48a465bad4dcbca28f5019f457968d45d6de5234e3c0a7b6965db0"
    sha256 x86_64_linux:   "90a34c5ad79a5990922ad05c811c45caabd70e67dabe9f4b581c5de40d5c6699"
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
