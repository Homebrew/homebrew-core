class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.16.2.tar.xz"
  sha256 "0e06a6191a0c6c16e16272bf2573cecaeb245f10629486ad940a299bef700c16"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-editing-services/"
    regex(/href=.*?gst(?:reamer)?-editing-services[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "08d783fd326d9c40cb2ec12b236d0fa560be509f364b2725e4e806855416e11d" => :catalina
    sha256 "e049cdc2cfe546f1367bb7b680e4b13dc013a1ff6f9c8175b63cadd200c8a875" => :mojave
    sha256 "db19177293d74892f5770fe76e57ee7c5cf42e3ab4e06c7e32c376053473882d" => :high_sierra
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
