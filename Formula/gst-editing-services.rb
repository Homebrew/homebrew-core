class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.8.1.tar.xz"
  sha256 "897babc2da242438992a2361a74cde16d3feb5eab56c653a3aeb553f45365020"

  bottle do
    sha256 "28f3187a1bdeece0242dfa792dc35e7dce4398faa43535a2621e3a48e899504f" => :el_capitan
    sha256 "0363cdae9d87834e3718ba72876f5bfe5cf4ba84b705d52330363cdc5cdf58c2" => :yosemite
    sha256 "2d67360df8f0fd284955fd67bc9cdeeb64cde858ace20fb731ca124f03e9d240" => :mavericks
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
