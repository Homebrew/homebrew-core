class Efl < Formula
  desc "Libraries for the Enlightenment window manager"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.14.2.tar.gz"
  sha256 "e5699d8183c1540fe45dddaf692254632f9131335e97a09cc313e866a150b42c"
  revision 2

  bottle do
    sha256 "a8e51818234a137bc021469bf37a52c84608d4e399420b71ff360682c8a7a8ae" => :el_capitan
    sha256 "a8fe89f450fc0328f84a442b138a93ebbdd516d03ccfe333e3c21fa080befd7f" => :yosemite
    sha256 "4d1e000d79e426ffaf82e1b4603239b2c629c8eab5549b29d403a2b88eca24f5" => :mavericks
  end

  option "with-docs", "Install development libraries/headers and HTML docs"

  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "luajit"
  depends_on "fribidi"
  depends_on "giflib"
  depends_on "libtiff"
  depends_on "gstreamer"
  depends_on "gst-plugins-good"
  depends_on "dbus"
  depends_on "pulseaudio"
  depends_on "bullet"
  depends_on :x11 => :optional
  depends_on "webp" => :optional

  needs :cxx11

  def install
    ENV.cxx11

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-cocoa
      --prefix=#{prefix}
    ]
    args << "--with-x11=none" if build.without? "x11"
    # There's currently (1.14) no clean profile for Mac OS, so we need to force
    # passing configure.
    args << "--enable-i-really-know-what-i-am-doing-and-that-this-will-probably-break-things-and-i-will-fix-them-myself-and-send-patches-aba"

    system "./configure", *args
    system "make", "install"
    system "make", "install-doc" if build.with? "docs"
  end

  test do
    system bin/"edje_cc", "-V"
  end
end
