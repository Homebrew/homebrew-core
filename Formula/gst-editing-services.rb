class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.14.2.tar.xz"
  sha256 "05b280d19eb637f17634d32eb3b5ac8963fc9b667aeff29dab3594dbdfc61f34"
  revision 1

  bottle do
    sha256 "831ffe600c209b6cf5de232ec88d855766c266ddc583a72552c06c8c1070d5cb" => :high_sierra
    sha256 "2165a0043372021c8c264fcb5a388fc5b01ed1b54f7afcef17cc5ba19a2051fd" => :sierra
    sha256 "58a5e50c51b8db69d11a1e2d4e7f92f87f53deadc68606bc307766b246df4d8f" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
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
