class Ddcutil < Formula
  desc "Control monitor settings using DDC/CI and USB"
  homepage "https://www.ddcutil.com"
  url "https://www.ddcutil.com/tarballs/ddcutil-2.2.7.tar.gz"
  sha256 "19ac6604cf1177ba56666f8a682581e71e8973bd06c7c8dcf033674e4aaaa648"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.ddcutil.com/releases/"
    regex(/href=.*?ddcutil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "604c2801d09419e20c2457f7aec8d605abd86b846d537ffbefd18665aa626012"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d7e228a9ada1605b7958660a90ce03cd5710e464a767b2a39c02a24f4e17c9fe"
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
