class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.12.3.tar.xz"
  sha256 "032e2fd040079259aec060d526bcb021c670f8d953219c229f80fdc541465f76"

  bottle do
    sha256 "f81d04cfa7be0cce421f730ff75c1688686480033950942e1f6bd92c02afa9cf" => :high_sierra
    sha256 "ac7fe0c4cc3a9da5164365c344a62b75db1170b06f1cfe1ce6a1c286215b7ec0" => :sierra
    sha256 "74d9860acab9197a1f5ac0263228fb23641b6448f3b402c3f59d203fa2ccc077" => :el_capitan
    sha256 "4ac67a9daffa3fa549696d9914f938f4d8ea656f5a2edf79bf243e56e07d463b" => :yosemite
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
