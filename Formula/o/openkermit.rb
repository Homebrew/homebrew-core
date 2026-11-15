class Openkermit < Formula
  desc "Scriptable network and serial communication for UNIX and VMS"
  homepage "https://www.openkermit.org/"
  url "https://github.com/openkermit/ckermit/archive/refs/tags/v11.1.517.tar.gz"
  sha256 "d691e0b6cceaf9c072f0b1003770ddab2cc5fe01ad2cf7365c4b5513991b509b"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "abd5181ffe057fc01a4d7de9a456d54624b6ef0ebca70f66b57d6070fb5921ea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a727d0d6d4f60ae6fedd4f90bd5d4e7bfeb3b667cc546e2a8988a3b8f3e37279"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "15b8bf3c59b13a76866ca7aee33daa177253ac0226a573fc93347020f60d70d3"
    sha256 cellar: :any,                 arm64_linux:       "9edb7edcb8ddb755503316180695eecd3d759a0eec3c99304a177e95384eb507"
    sha256 cellar: :any,                 x86_64_linux:      "dbe73aa2f29e52179b4eb872878f9a85a52fa23617f215de269529c1cf23c4a3"
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
