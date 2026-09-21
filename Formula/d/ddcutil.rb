class Ddcutil < Formula
  desc "Control monitor settings using DDC/CI and USB"
  homepage "https://www.ddcutil.com"
  url "https://www.ddcutil.com/tarballs/ddcutil-3.0.1.tar.gz"
  sha256 "1c862dc263aa295f23da8d9a6693487d4cd8c97a91bdeaa4711cab28a33cdd6e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.ddcutil.com/releases/"
    regex(/href=.*?ddcutil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "2843102c185aff788228191b726a58f740af677e2770eb365592e60b277b2165"
    sha256 cellar: :any, x86_64_linux: "48639152a987609897a84ad36d4e6f9821957eeaf1b71950aa115817f68f3691"
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
