class Ophcrack < Formula
  desc "Microsoft Windows password cracker using rainbow tables"
  homepage "https://ophcrack.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ophcrack/ophcrack/3.8.0/ophcrack-3.8.0.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/o/ophcrack/ophcrack_3.8.0.orig.tar.bz2"
  sha256 "048a6df57983a3a5a31ac7c4ec12df16aa49e652a29676d93d4ef959d50aeee0"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "9bbddef8954e48336a179c36c62eef0a235511bdecb8c341c623a462e7511951"
    sha256 cellar: :any,                 arm64_sequoia: "8c86de3d503ed9186c88fc7beec9e69f4530ab19c35bc7a981ef7fd0be1b14ff"
    sha256 cellar: :any,                 arm64_sonoma:  "16b08335d1e88acaef2b74387a312fef64fc4bbeb947ffd36ebcff4c69b23419"
    sha256 cellar: :any,                 sonoma:        "25e508ee96b66c1258dae94b2067e222f13926da239965a757291bf5ffb76e88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df28087f7aeb845c3f81b353c1bbcc04aeba7609147443c4c100ce1366234076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94dae3f25b89faf64f1c609072dc6b4a0b45b0cd81e7174afce201cdfd9c15a1"
  end

  depends_on "openssl@4"

  uses_from_macos "expat"

  def install
    args = %W[
      --disable-gui
      --with-libssl=#{Formula["openssl@4"].opt_prefix}
    ]
    args << "--with-libexpat=#{Formula["expat"].opt_prefix}" if OS.linux?

    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm64?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"ophcrack", "-h"
  end
end
