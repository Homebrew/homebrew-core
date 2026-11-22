class Openkermit < Formula
  desc "Scriptable network and serial communication for UNIX and VMS"
  homepage "https://www.openkermit.org/"
  url "https://github.com/openkermit/ckermit/archive/refs/tags/v11.1.520.tar.gz"
  sha256 "a0b8454a651c56339c5ef7e1091eedbc340a34e6189755d99c1ca861abaa8bef"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "742d4a5d7996a6616efb961f59d6609977b8d820519436bf77b2cebcaaad48d4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "49895aeb70b19c12a4b7f7a2d4287d60a629d2a1d5f7b49d9394cc19db649de2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e202564113be18fcea32a92b1c4cce0aa6032c4ae86485c97b0110d21762c50e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "410c3f50a416b40f2a750e1418f98b8f1644919d98a76d5b37f831fbb2823c49"
    sha256 cellar: :any,                 arm64_linux:       "e686c7df3fe74bc84b0abfe0fa2299af1ad2ff565c4c54496828fb7c91d3a9d3"
    sha256 cellar: :any,                 x86_64_linux:      "262ab432581836b13a0beebaf3ebcef57fe17d03f2c13878709f4168c08ef4ae"
  end

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  def install
    os = OS.mac? ? "macosx" : "linux"
    system "make", os, "KFLAGS=-DCK_NCURSES -I#{formula_opt_include("ncurses")}"

    man1.mkpath

    # The makefile adds /man to the end of manroot when running install
    # hence we pass share here, not man.  If we don't pass anything it
    # uses {prefix}/man
    system "make", "prefix=#{prefix}", "manroot=#{share}", "install"
  end

  test do
    # /confirm:off keeps this headless.
    system "#{bin}/kermit", "-C",
           "set host /network-type:pseudoterminal \"kermit -x\", get /confirm:off /bin/sh, bye, quit"
    assert_path_exists "sh"
  end
end
