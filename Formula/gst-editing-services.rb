class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.10.2.tar.xz"
  sha256 "db159aeb9df5959f7b246d4b6fcbc8d01cec2ced6d539d00c608458a245fa743"

  bottle do
    sha256 "0a406fa3daa4cd8ea821bd68f253542ee83d52cd25e491ac36ff208aeba969e7" => :sierra
    sha256 "b7ce48cca7c914fb360921cae01e026b80ce78aba2f00853a34aa228c9d3d4cd" => :el_capitan
    sha256 "a09af15d47c117d0a1105153c9a67678f66d5687c763ace068c7027e5e90b190" => :yosemite
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
