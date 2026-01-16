class Bastet < Formula
  desc "Bastard Tetris"
  homepage "https://fph.altervista.org/prog/bastet.html"
  url "https://github.com/fph/bastet/archive/refs/tags/0.43.2.tar.gz"
  sha256 "f219510afc1d83e4651fbffd5921b1e0b926d5311da4f8fa7df103dc7f2c403f"
  license "GPL-3.0-or-later"
  revision 13

  no_autobump! because: :requires_manual_review

  bottle do
    sha256               arm64_tahoe:   "4a36aae44f8d7241586755bf287e97d22d9c25a7063a829a4c27acf0f334e6ab"
    sha256               arm64_sequoia: "f1ccdafb2925637af27c5823319c1e35b328d1376e78f10352b51c7dc14c80b8"
    sha256               arm64_sonoma:  "c5f9832aa81c9273df5cd6e9ed889e232ba4b2b404959159b83d65d70b8749d7"
    sha256 cellar: :any, sonoma:        "a3b4dd087d6c1a9ebc3bd49d738bba4934e67120aae88c9ca48a78b92145e9f9"
    sha256               arm64_linux:   "78ece6016f523525d749e367e4bbef4de709ac426add7c8ff7fb6db45480aedb"
    sha256               x86_64_linux:  "27a2d5d98345001280889ceaf575f39c65519dacd8a6f45b197c0d24714ac1fc"
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

    ENV.append "CXX", "-std=c++14"

    system "make", "all"

    # this must exist for games to be saved globally
    (var/"games").mkpath
    touch "#{var}/games/bastet.scores2"

    bin.install "bastet"
    man6.install "bastet.6"
  end

  test do
    pid = spawn bin/"bastet"
    sleep 3
    assert_path_exists bin/"bastet"
    assert_predicate bin/"bastet", :executable?
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
