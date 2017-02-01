class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.10.3.tar.xz"
  sha256 "bcbf52ad789be44abc6bb68c96457683438b2a1d966a3f408c8c931ae2c2a32b"

  bottle do
    sha256 "ae6fd39790253485e03ada3db8950527aec2a76685d6d36647605ca73e49218f" => :sierra
    sha256 "8a9bc56fd6e9ea9f1d45b2ff851a6027e825a770ae045d19c0208a3e04db54c3" => :el_capitan
    sha256 "7f37148503392dd9521d29f459f8b4f2db6e70f7360cde7de644d947299ed16b" => :yosemite
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
