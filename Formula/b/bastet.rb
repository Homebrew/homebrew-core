class Bastet < Formula
  desc "Bastard Tetris"
  homepage "https://fph.altervista.org/prog/bastet.html"
  url "https://github.com/fph/bastet/archive/refs/tags/0.43.2.tar.gz"
  sha256 "f219510afc1d83e4651fbffd5921b1e0b926d5311da4f8fa7df103dc7f2c403f"
  license "GPL-3.0-or-later"
  revision 12

  no_autobump! because: :requires_manual_review

  bottle do
    sha256               arm64_tahoe:   "bd1d97bd3983d3531e2e3bde824f690e527db5cce1d884602631a8cd387053cf"
    sha256               arm64_sequoia: "4610cfc2730928d36fc2c129de55b26257ceb5e13821142529ff948660073bf6"
    sha256               arm64_sonoma:  "246ad961cdfb6d5c55993faabe240444589c870cbc5eb2567130f53ec94bc6f0"
    sha256               arm64_ventura: "a0862ef06147f76cf326257d45eea42597330c5c45f631317b1c8c39ccd5136f"
    sha256 cellar: :any, sonoma:        "98a67787b19ac466bcca7bdb637815e7baf9c3dcaefd03a69a4f240c6600c60b"
    sha256 cellar: :any, ventura:       "ad8b5e6d2c65c9d503d57401856729551a993e34d6201f396a52c8e811f349b4"
    sha256               arm64_linux:   "e2e97c4de86dffae54d79bcf9afd9283e1014968dc67b426e57a963c69232e9a"
    sha256               x86_64_linux:  "fac2d3e5ddb3dde86764be8ae0072842f3c985c7393ca3fc75fba495f72ad2d1"
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
    pid = fork do
      exec bin/"bastet"
    end
    sleep 3

    assert_path_exists bin/"bastet"
    assert_predicate bin/"bastet", :executable?
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
