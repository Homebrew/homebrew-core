class Bastet < Formula
  desc "Bastard Tetris"
  homepage "https://fph.altervista.org/prog/bastet.html"
  url "https://github.com/fph/bastet/archive/refs/tags/0.43.2.tar.gz"
  sha256 "f219510afc1d83e4651fbffd5921b1e0b926d5311da4f8fa7df103dc7f2c403f"
  license "GPL-3.0-or-later"
  revision 14

  bottle do
    sha256               arm64_tahoe:   "73941341ccf91830b8dd0cd64bcb8c2aab15cd1ef32082e28434088a0d300d21"
    sha256               arm64_sequoia: "904d583b0e0e6441912a33af22a41e57ca88200d29eac2f7a9006210cc8b6c4c"
    sha256               arm64_sonoma:  "94e82566f4497c546592c4afef16fbfacd51e150376307158b19d5a40039c258"
    sha256 cellar: :any, sonoma:        "374aa3798365f71800439427f00124d0751ae02df4d6e193885485fd0c05815d"
    sha256               arm64_linux:   "1fe8c247c28b51fbcff914df7f6260303ed3f1cf642e49c9399171fd3f3c9d3b"
    sha256               x86_64_linux:  "25f3108f2e4a33beef995c0e5ce2ff06c82a48b801cb71b6f238215a1b146b5e"
  end

  depends_on "boost"
  uses_from_macos "ncurses"

  # Fix compilation with Boost >= 1.65, remove for next release
  patch do
    url "https://github.com/fph/bastet/commit/0e03f8d4d6bc6949cf1c447e632ce0d1b98c4be1.patch?full_index=1"
    sha256 "9b937d070a4faf150f60f82ace790c7a1119cff0685b52edf579740d2c415d7b"
    type :backport
    resolves "https://github.com/fph/bastet/issues/6"
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
