class Arping < Formula
  desc "Utility to check whether MAC addresses are already taken on a LAN"
  homepage "https://github.com/ThomasHabets/arping"
  url "https://github.com/ThomasHabets/arping/archive/refs/tags/arping-2.28.tar.gz"
  sha256 "43b94dbb96d288096ebe0e81c0411c2e69d329d7447ac1fd7b758eda38fd35a8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dc8c29ee0f45d69f2d0a34ea300d46379d41cfa1f551c3dcf32a12cb4f299f4c"
    sha256 cellar: :any,                 arm64_sequoia: "354ef9db34e2aa56586faeb87a8303f2bc15412645bd3ccb388b6de570fa9d9f"
    sha256 cellar: :any,                 arm64_sonoma:  "3bbc282a841a98e362241b8678207bdcb1f7982a5ee190ae4f72193e08ac0693"
    sha256 cellar: :any,                 sonoma:        "cebc2ab2ac9c7781eb24bfcc1148e9e553f400a8f6603e46cbdbfd4c175d6269"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "649e47c98c1f5ac7b109423c48ac8e376214c4404d4022b1f03d9111054e25f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a7775d5a971141ca866af205bcf2dee52af6dd736422afed98cbe5f5d1d75f5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libnet"

  uses_from_macos "libpcap"

  def install
    system "./bootstrap.sh"
    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    system "#{sbin}/arping", "--help"
  end
end
