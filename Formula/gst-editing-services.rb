class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.12.0.tar.xz"
  sha256 "993372f80cafd5395e90a4bc8bf28733513949a2ae4df987ab0dcc99fc5bab66"

  bottle do
    sha256 "4de13512623b07c7a6e4f27bec1db9dcdaddd9f306eed1b73ef68dcff7946f08" => :sierra
    sha256 "252056cae367267b48b89027240ed5ae792b4a776a769f87eea02b946c2ac23a" => :el_capitan
    sha256 "b13745810f44d2fc2e44a9d9f3f9fc61751c97bc0f89d79919c2bee7bf8eb6af" => :yosemite
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
