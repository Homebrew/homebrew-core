class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.16.1.tar.xz"
  sha256 "c884878f9e6ddac96e4f174654d12fe52e3d48eaaec27a80767c0d56cb2f6780"

  bottle do
    sha256 "5ebd13bc464225a29a9a0855eafdc3ef87afc60a159fcab3fa581da42d96128f" => :mojave
    sha256 "517ed6563280d1e022c1859fee6df08edee39436f5935ac4b94d24d9295c0a42" => :high_sierra
    sha256 "46a593dc38290e2b435f66b10815614c88b7bd00d68cacf4264b5480a2a1f316" => :sierra
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
