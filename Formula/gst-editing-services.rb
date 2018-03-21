class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.14.0.tar.xz"
  sha256 "8d5f90eb532f4cf4aa1466807ef92b05bd1705970d7aabe10066929bbc698d91"
  revision 1

  bottle do
    sha256 "771d7b375ea4294c3775fd5e170972ec11dec3f64b1e02fb5173b42c47793af1" => :high_sierra
    sha256 "ff1a6848c4119cad9ee0bb61befada7ef8cdb2ce45cb34c306e69a06b7c59598" => :sierra
    sha256 "d97b2fe56704c11f0c32d41c1b73bffb5597aae6908535e7fc8301ec8103dc35" => :el_capitan
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
