class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.14.4.tar.xz"
  sha256 "53d1d25b356009505ae0d22c218d6c6b1215399d9f6e3fe5d7b88e156531b35f"

  bottle do
    sha256 "e432b536f6359bd218b492fe79f938f4ff8ae65475c2afe177c510f3d5b1e004" => :mojave
    sha256 "8bcb855c81d47601e528e1262698ae71047f3b632819e8f7619b2982c233d414" => :high_sierra
    sha256 "3c9491a57f8c409ac35b2b4e389d22350aa056ca8a92b31a029361222014506d" => :sierra
    sha256 "9eeb2a72c99677b9f9725b214929cef4542c78eb2cb3cf05e37b42abfa5bd318" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "gst-plugins-base"
  depends_on "gstreamer"

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
