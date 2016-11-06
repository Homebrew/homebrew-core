class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.10.0.tar.xz"
  sha256 "1f2c8b8ba33c1cc746f129bb9d6b85e5fc4eff5fbb1c85bbc2c5b6683362560c"

  bottle do
    sha256 "0ffcda1ae32f30fb11019fa191a8b3d4ccd5c6b717bc787d9265f1a02906b3e5" => :sierra
    sha256 "cc2c75248812f2385cc4ef9520f2f50b900180df8f24d06eaa2c3faed553a678" => :el_capitan
    sha256 "d3c44ee64b7b467f4dc7500361b1cc607c49ab1258e266c82e2f74d520d84e33" => :yosemite
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
