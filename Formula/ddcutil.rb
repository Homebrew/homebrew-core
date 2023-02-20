class Ddcutil < Formula
  desc "Control monitor settings using DDC/CI and USB"
  homepage "https://www.ddcutil.com"
  url "https://www.ddcutil.com/tarballs/ddcutil-1.4.2.tar.gz"
  sha256 "355f547df3e9bca6a5859c54ca48e634e8e3cbd7f596ebeec789ba61d7f7a5ae"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.ddcutil.com/releases/"
    regex(/href=.*?ddcutil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "52583dfb866c178c7b47ff0d804df360adbd18b85f6ae76ca0a80d9a7372e18d"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "i2c-tools"
  depends_on "kmod"
  depends_on "libdrm"
  depends_on "libusb"
  depends_on "libxrandr"
  depends_on :linux
  depends_on "systemd"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "The following tests probe the runtime environment using \
multiple overlapping methods.", shell_output("#{bin}/ddcutil environment")
  end
end
