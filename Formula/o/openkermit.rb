class Openkermit < Formula
  desc "Scriptable network and serial communication for UNIX and VMS"
  homepage "https://www.openkermit.org/"
  url "https://github.com/openkermit/ckermit/archive/refs/tags/v11.1.516.tar.gz"
  sha256 "220ed74640bf6a89698b4436f3f0fbe9b073cb0d7782392028f5cde5867bff7b"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fd4c015f1e4713f6d5ca3ee01867c00ce11b47b5b5219819ba2e391c2e1d9bc1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "03c5320aa114c192febc40597a35fc56198821b93c6630329b94a89fa290aacb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eca14317f7cc0aa490fbfc15f5260c23f75672ba3782361ef43b2ac912dfc2bc"
    sha256 cellar: :any,                 arm64_linux:       "5e7e968678c333fab38ddba006531370ab29b4fca0998f0a4f14caf683d67cb6"
    sha256 cellar: :any,                 x86_64_linux:      "f3dba795a148410af7e21d04e69da90b580545a50e7dfc1615a54ac13ef6e22f"
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
