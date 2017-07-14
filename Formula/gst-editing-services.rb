class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.12.2.tar.xz"
  sha256 "59c75497b53d36f020cb0cb7c7b9ae7545f5b47fd6e4406d4f3391741071202e"

  bottle do
    sha256 "94a5b2f8857d8be234033003b17495ed2b3833a63678d7ebaed3c22a02e316ef" => :sierra
    sha256 "fc4abeaba2111fc07b4dea9feca1a2ebee0afd3189a7ec3cadc1dba516269794" => :el_capitan
    sha256 "2dd974c9feae0441a21ca1ffd86507ae91040b4eb03c1b1aa51def47b42bd616" => :yosemite
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
