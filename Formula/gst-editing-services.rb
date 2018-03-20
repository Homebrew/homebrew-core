class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.14.0.tar.xz"
  sha256 "8d5f90eb532f4cf4aa1466807ef92b05bd1705970d7aabe10066929bbc698d91"

  bottle do
    sha256 "37e28bb8f36efa80c581272186f365201088cbb52f45b186e1e2775dbc2eb973" => :high_sierra
    sha256 "8ca9dbc7b05c1baf13f550f297636016be20119d93343b985d9781e6353b490c" => :sierra
    sha256 "c99951c37bd5b03778d57141b7fe6755ad7c54d524f995c23b48f99f219cb808" => :el_capitan
  end

  depends_on "gstreamer"
  depends_on "gst-plugins-base"

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
