class Arping < Formula
  desc "Utility to check whether MAC addresses are already taken on a LAN"
  homepage "https://github.com/ThomasHabets/arping"
  url "https://github.com/ThomasHabets/arping/archive/refs/tags/arping-2.24.tar.gz"
  sha256 "e443f65a44e247b27da8177decac31aa84336d5de87eab44fc02e33e7ba0b251"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2dbbead3a75d49794f13bb3c51891e22711ab9fc506e53139c061b6d8e3658c3"
    sha256 cellar: :any,                 arm64_ventura:  "9527fdcea88db09d128a4e85080024d7a1343dd0dbc1c73d226593859b63132f"
    sha256 cellar: :any,                 arm64_monterey: "3ebf50e297b1dc1ce809a28cd3467d3122bf7f85a923f65a4e755a951ea29482"
    sha256 cellar: :any,                 sonoma:         "c5b13cc6caf9e28b37283798265459cc494955e9f7fb186fbf1ebd0e65a3b4b3"
    sha256 cellar: :any,                 ventura:        "bf560ca2a6747a15fd7c20f5a0a5df1baae96bb902aaa5e97d4661f05323f66b"
    sha256 cellar: :any,                 monterey:       "846f905f680a6ec181bfcc791cb2529f21ee6eff3165b2c5d48376742f0ad247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8880c2d7a238a5c1b5cba68b3357c914723da9368725354fb63db2b8423a6d2c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libnet"

  uses_from_macos "libpcap"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/arping", "--help"
  end
end
