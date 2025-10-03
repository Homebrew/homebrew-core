class Libiptcdata < Formula
  desc "Virtual package provided by libiptcdata0"
  homepage "https://libiptcdata.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libiptcdata/libiptcdata/1.0.4/libiptcdata-1.0.4.tar.gz"
  sha256 "79f63b8ce71ee45cefd34efbb66e39a22101443f4060809b8fc29c5eebdcee0e"
  license "LGPL-2.0-only"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "1c4ed377f24990f0602ed171149c4da26c7986f746c7aa5c5486fc753dfc49e9"
    sha256 arm64_sequoia:  "ccdaa3847cffb9073eba5796d92eb08f1dd1c9b1bcda21f45d64a654f0dcfdac"
    sha256 arm64_sonoma:   "e7b09d218f871a5252b465841f6001896d867247175f228c3d50164cd9fefa1a"
    sha256 arm64_ventura:  "5543254a38d990ac3eabb48f51dda1eacd65fbea211200d825063385affcc014"
    sha256 arm64_monterey: "479e59e0cffe5a692546ef0bee8552cdbd43fdf6353c5c04721e92372d92f671"
    sha256 arm64_big_sur:  "45d61d51cb3e5607763ed374d5cc88e4a7c6dc8b1ba08ccd276c3379a20646bf"
    sha256 sonoma:         "b65a559689911c0a84e3d7f8a1a4255dd411bb03b2d8b00355f453b28ccf99f3"
    sha256 ventura:        "66ab47a907199d944b1af5b10efdd6a90b255a35395cdb69ac637253648d9d20"
    sha256 monterey:       "e93e2ffd79bb784e528ed8f8b197b808090f3cc0b653da0cc880f88db984094f"
    sha256 big_sur:        "5bb2bce1d8a877c84abb51f3b9d9e0c40588bdeb2d6ea8d66c6de230d2e35e8d"
    sha256 catalina:       "1dbcf1dd89b05f7f1fdc1a15d9c56b7e726f7296d8096ccae22fed9adf36790a"
    sha256 arm64_linux:    "c9c24c8b0b36c40568552242ede97e1efd500063008dc546b84ac6d2451bc455"
    sha256 x86_64_linux:   "4e929a2391eb2733d481f84b82cc925a1d0cf943bed4f99af876f4240b62c9c0"
  end

  on_macos do
    depends_on "gettext"
  end

  def install
    # Fix flat namespace usage
    inreplace "configure", "${wl}-flat_namespace ${wl}-undefined ${wl}suppress", "${wl}-undefined ${wl}dynamic_lookup"

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iptc --version")
    assert_match "ModelVersion", shell_output("#{bin}/iptc --list")
  end
end
