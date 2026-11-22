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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5ad39a45ff72db2a4f5fc8e33c9e72ea32b9c241d111cd86fb25284a0645d9b5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "72c59e610985186c3e4a04d62c81b131b85c180b23aa0f00f060fc2778f7c8eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c34680dce3a04766ffb3b82cc3ba4151c8fac9ac9dda2a7f51b553b90a228f4f"
    sha256 cellar: :any,                 arm64_linux:       "d036375e54ef52287c5de924a5030a24283272f5ca5e954cec53c4a14dcbeb9c"
    sha256 cellar: :any,                 x86_64_linux:      "eff49d3337a54d3e7279e3e7eb41b04d3846843e7f8388aef5ce45145724bf14"
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
