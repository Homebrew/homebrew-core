class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.14.4.tar.xz"
  sha256 "53d1d25b356009505ae0d22c218d6c6b1215399d9f6e3fe5d7b88e156531b35f"

  bottle do
    sha256 "52e97704b23a052cfdcc63d669e740ad9bc57ee31e7284f54a6f26f057686405" => :mojave
    sha256 "962d5a55d1eadf89696469d523ea7889313dcf1093bfef6d6c5babc78e4fa212" => :high_sierra
    sha256 "b558c069cf73e4bb82c15db8fd48e75ed86b5c015bd79173c176ee8562af1c99" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "gst-plugins-base"
  depends_on "gstreamer"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-gtk-doc",
                          "--disable-docbook"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ges-launch-1.0", "--ges-version"
  end
end
