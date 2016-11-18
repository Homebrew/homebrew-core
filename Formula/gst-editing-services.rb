class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.10.1.tar.xz"
  sha256 "e9c60f454726aaa0a1dbc7b6e192f9a0a23733ea5680b474a0abc5fad7ed0d11"

  bottle do
    sha256 "44317235a95ba598c3a271fb7caed5903b5028de7d182d590bac4cc2375c3e45" => :sierra
    sha256 "0fde9c89668bf0b8eb9946c16bd515e6accfc5abb4611648226b409cca53b33a" => :el_capitan
    sha256 "5c3eec0a16620a1e4e8e338591c8f25dd0a08078b20a1e075b701765a06d08d6" => :yosemite
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
