class Libxp < Formula
  desc "X Print Client Library"
  homepage "https://gitlab.freedesktop.org/xorg/lib/libxp"
  url "https://gitlab.freedesktop.org/xorg/lib/libxp/-/archive/libXp-1.0.4/libxp-libXp-1.0.4.tar.bz2"
  sha256 "81468f6d5d8d8f847aac50af60b36c43d84d976d907ab1dfd667683dbfb5fb90"
  license "MIT"

  livecheck do
    url :stable
    regex(/^libXp[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f92106b34661b7a8d39636a544ee208e724b2ac68395ca4a9b2ef264359190f9"
    sha256 cellar: :any,                 arm64_monterey: "c2e8285bdd8edb318e57e2b9d47e692d283cc05ac7ba811468ce946a9070fa1f"
    sha256 cellar: :any,                 arm64_big_sur:  "e44f5fc9fafc1b6c40c6051921f6de14d2a0d6a01c5fd9715341bb77e5ccd144"
    sha256 cellar: :any,                 ventura:        "f23541f38685321e6ff2d041a19391b2a7e88e788e794170ba8fed668134f36d"
    sha256 cellar: :any,                 monterey:       "afa942a7ef9f5244bcfd7ce8e61b8235e3085f41bdc521bb3c930eb9402ff8bb"
    sha256 cellar: :any,                 big_sur:        "ebf2ccca3126f773869610f9ca07888226e6caf7ab90a3b493aeadbf81354022"
    sha256 cellar: :any,                 catalina:       "0687d2c037f00590ebf445e0b7f5531a703ddd8390dc903eaacbd451fdd10a6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff2541a82e9806bac37aedb6fcaa83846e4f4d8710d4ea632a09fe826746da99"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "util-macros" => :build
  depends_on "libx11"
  depends_on "libxext"

  resource "printproto" do
    url "https://gitlab.freedesktop.org/xorg/proto/printproto/-/archive/printproto-1.0.5/printproto-printproto-1.0.5.tar.bz2"
    sha256 "f2819d05a906a1bc2d2aea15e43f3d372aac39743d270eb96129c9e7963d648d"
  end

  def install
    resource("printproto").stage do
      system "sh", "autogen.sh"
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"
    system "sh", "autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags xp").chomp
  end
end
