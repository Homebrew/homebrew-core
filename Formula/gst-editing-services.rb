class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.8.2.tar.xz"
  sha256 "a1d57ff9461407cca1f6e7a9f31a5bdb73f73f33c488a3e3318b27e10a4332ae"

  bottle do
    sha256 "e737bba823133765f5fab9ab033c9e80e5342d8ad04654a55695290cf468b585" => :el_capitan
    sha256 "7b9262b2023059bb6c9f2a52c3e4065e15abd7e7102b30cba272ecb5b1340387" => :yosemite
    sha256 "8a2b903f27d6265665c5f0a12fedd87f9efb34cb41c347097cc37f10ca5f9175" => :mavericks
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
