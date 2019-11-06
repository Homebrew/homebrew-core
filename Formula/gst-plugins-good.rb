class GstPluginsGood < Formula
  desc "GStreamer plugins (well-supported, under the LGPL)"
  homepage "https://gstreamer.freedesktop.org/"

  stable do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.16.1.tar.xz"
    sha256 "9fbabe69018fcec707df0b71150168776040cde6c1a26bb5a82a136755fa8f1f"
  end

  bottle do
    sha256 "070e2e81a5b6020655a6ca7ccd2d23a4f07769a4b6b63ef82560a91a79ca681d" => :catalina
    sha256 "673f6063b41897bc8459c1bab7645c8d1b5bd2fd0d76487377bae0aea6515be5" => :mojave
    sha256 "e5779ab58e4fc5c01bd5d0d0ed06cfe27ceee5777057a65170cdf09d4f0046b1" => :high_sierra
    sha256 "53b2bd6a52bd0aab3f45a28023d0e973f120047614f18fc91520bf70943994cb" => :sierra
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-plugins-good.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "check"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "flac"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "gtk+3"
  depends_on "jpeg"
  depends_on "lame"
  depends_on "libpng"
  depends_on "libshout"
  depends_on "libsoup"
  depends_on "libvpx"
  depends_on "orc"
  depends_on "speex"
  depends_on "taglib"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-gtk-doc
      --disable-goom
      --with-default-videosink=ximagesink
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-x
    ]

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin cairo")
    assert_match version.to_s, output
  end
end
