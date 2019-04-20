class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.16.0.tar.xz"
  sha256 "82a3faefb2b0d91e134fd02cddeee718b7846a07cbf0127fed7aa03e25495ad1"

  bottle do
    sha256 "27b5901b6ff65e823ded24927634f6b1eae68d7aa53a1123dadf53ad5ad8603b" => :mojave
    sha256 "03fd08854757d665c0d5825cdcd69bf6bda7eb04b514acd699467f5e0b99660d" => :high_sierra
    sha256 "1ce50f56ed959bf40b3a085d1693bc9e678518c19113e7131da9a987c1427133" => :sierra
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
