class Libxp < Formula
  desc "X Print Client Library"
  homepage "https://gitlab.freedesktop.org/xorg/lib/libxp"
  url "https://gitlab.freedesktop.org/xorg/lib/libxp/-/archive/libXp-1.0.3/libxp-libXp-1.0.3.tar.bz2"
  sha256 "bd1e449572359921dd5fa20707757f57d7535aff1772570ab2c29c6b49b86266"
  license "MIT"

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
