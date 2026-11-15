class Ddcutil < Formula
  desc "Control monitor settings using DDC/CI and USB"
  homepage "https://www.ddcutil.com"
  url "https://www.ddcutil.com/tarballs/ddcutil-3.0.2.tar.gz"
  sha256 "2ebcf0c75ee21e22fcc186d73dc38a2dc4cd7a296ac1fef66d740e795dac80d9"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://www.ddcutil.com/releases/"
    regex(/href=.*?ddcutil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "87f4e8d5dc4efe35081c072a037668c2d9f20f03c32876835ced7a5484b861a2"
    sha256 cellar: :any, x86_64_linux: "9465c739b8d14068938ced8f1aca7b5769318d50f5a33506a7e5bbc2b83477da"
  end

  depends_on "pkgconf" => :build
  depends_on "acl"
  depends_on "dbus"
  depends_on "glib"
  depends_on "i2c-tools"
  depends_on "jansson"
  depends_on "kmod"
  depends_on "libdrm"
  depends_on "libusb"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxrandr"
  depends_on :linux
  depends_on "systemd"

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "The following tests probe the runtime environment using multiple overlapping methods.",
      shell_output("#{bin}/ddcutil environment")
  end
end
