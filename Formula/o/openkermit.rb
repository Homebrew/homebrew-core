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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aace7c4e40cecaac4657f41ba3c30ae2ac5ecbf43245808879f3007185aeacfc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2f67d050e5220491048f38579ef408a37b0d73442b54bfcf86647706e288f8e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9852c97d167e4124e2ff84e38c08c5e2429526f02456a0722675be1f6576b430"
    sha256 cellar: :any,                 arm64_linux:       "5561690f5cf1145315b329f0ead3078f06a1094c40b0a35c9d927aa37b958165"
    sha256 cellar: :any,                 x86_64_linux:      "5c74ca0df9e9c86b80ac5b4b693e1a295ce6516be1411b83362b16f03904c620"
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
