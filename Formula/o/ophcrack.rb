class Ophcrack < Formula
  desc "Microsoft Windows password cracker using rainbow tables"
  homepage "https://ophcrack.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ophcrack/ophcrack/3.8.0/ophcrack-3.8.0.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/o/ophcrack/ophcrack_3.8.0.orig.tar.bz2"
  sha256 "048a6df57983a3a5a31ac7c4ec12df16aa49e652a29676d93d4ef959d50aeee0"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "2553d9e208e58765c20d11a8ce7a24ba4564caca492eaeec39ff7f3143452bed"
    sha256 cellar: :any,                 arm64_sequoia:  "2cc621ee5589b47e95841913aaa74aa64a404c677c3ab2062413c17424db56f2"
    sha256 cellar: :any,                 arm64_sonoma:   "49dd51ca8558b2ee8d1604f71cfefc6ab5d154ed98e979c20493cf81ee0928ae"
    sha256 cellar: :any,                 arm64_ventura:  "2944016f7c83334b70e9be541ddb4dc1da3fd8153234897cfe133ae29e336afc"
    sha256 cellar: :any,                 arm64_monterey: "37ecbad244ecc446c4bbdffe9d0826c76ef775e40e690b4f41dbc6c6630fdfde"
    sha256 cellar: :any,                 arm64_big_sur:  "d8c3ea08b451c0c0d27ca20e531f902fdf9b4fde1eb1fb76759dc5a7e931faab"
    sha256 cellar: :any,                 sonoma:         "03a63578e3db4ec721c74962a36a81bf3c417d05f8c557240ce0791a8c74ef4b"
    sha256 cellar: :any,                 ventura:        "fe4a6f346518d3efcfeefba25b473deb83ff1ca2701110551eed83c8c53e0e9a"
    sha256 cellar: :any,                 monterey:       "c96ec9cc73e454864271c1a8decfa64b7a5b81a2a7a26a54713167d12fd7e770"
    sha256 cellar: :any,                 big_sur:        "5a15aea7e8140b19119e29c2d4b8766a1f61bdef196458e684a95bcaaa81ad7d"
    sha256 cellar: :any,                 catalina:       "0b0e6f27354207ce5939fd31581c7913c64824752ba6e217c097dcc17041221c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fe021b18a96a207453ab400f344773412a39a7d1a527bcc2bb1b76417f2e13b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18e7c06d3f04cebc060e100f2b1a8c5825736fbd13047e6f1732a7e2d006235e"
  end

  depends_on "openssl@3"

  uses_from_macos "expat"

  def install
    args = %W[
      --disable-gui
      --with-libssl=#{Formula["openssl@3"].opt_prefix}
    ]
    args << "--with-libexpat=#{Formula["expat"].opt_prefix}" if OS.linux?

    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"ophcrack", "-h"
  end
end
