class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.10.0.tar.xz"
  sha256 "1f2c8b8ba33c1cc746f129bb9d6b85e5fc4eff5fbb1c85bbc2c5b6683362560c"

  bottle do
    sha256 "904dab5c27793e042b8011c865dd54cc646f54d4919351bf4cdd22f6e4f29190" => :sierra
    sha256 "0700828b35f87a30550a67407b37efe2c4f3a95e0862b47a341c83c20583722b" => :el_capitan
    sha256 "ed4d5a32de582c6909316e096dbf89ce3c11165b734e613114aa2b1c61ec692a" => :yosemite
    sha256 "301359de1f3de795464c84d36f9685caf4f2acf54f8d722c997812a2da8b480e" => :mavericks
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
