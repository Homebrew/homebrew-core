class Openkermit < Formula
  desc "Scriptable network and serial communication for UNIX and VMS"
  homepage "https://www.openkermit.org/"
  url "https://github.com/openkermit/ckermit/archive/refs/tags/v11.0.511.tar.gz"
  sha256 "baaa0abadf7900a2770f179ddeb6a5fe71891c8bae8805ea633f0bc284e2c39c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "637d52a0da7a88b2b81f521b4a472cb290ccedeb1b54fc9876e0633996b942cd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1434a15ffca3a0e0aa14e9e44b2e15345e721b3e5ca3517df4c6af1782ebb7b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5c8edd03bbd81f1790157bff4fa5b19fd7ff3e8a5ac95ca079d16f05adb4bb78"
    sha256 cellar: :any,                 arm64_linux:       "ce7aa235cf09529d121a08772f4ee52b1a1fa57ddac0e9f050624c269194ac63"
    sha256 cellar: :any,                 x86_64_linux:      "72e416a4962262a7192ef31d59a7f383e642796e5a89584a9c64c190f7de8c67"
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
