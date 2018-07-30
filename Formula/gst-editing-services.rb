class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.14.2.tar.xz"
  sha256 "05b280d19eb637f17634d32eb3b5ac8963fc9b667aeff29dab3594dbdfc61f34"
  revision 1

  bottle do
    cellar :any
    sha256 "67704afaf2671b482fa52394a73d6636059f1bf8046604980da05598caf49969" => :high_sierra
    sha256 "31f21382b2c7869e061e86e24ec14604f570b5b2b5f5cb76f1186a6eb7e104c7" => :sierra
    sha256 "ac06a59d8c48026c42c86c8ee216b98e0ca4b490144c4b9c5c4efd59cef0c84d" => :el_capitan
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
