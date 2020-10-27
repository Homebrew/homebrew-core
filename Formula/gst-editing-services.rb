class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gst-editing-services-1.18.0.tar.xz"
  sha256 "4daef0d4875415ea262f7fb1287d4a33939a9594f3c1e661f8587ab00f7000a8"
  license "LGPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-editing-services/"
    regex(/href=.*?gst(?:reamer)?-editing-services[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "6186de7daeaa8962f9f92e20903ffc91e106a28dadd0060d7ab001ff8acab890" => :catalina
    sha256 "eab524514fdaa2ea301d0956dfe706199c91606b96bbae802074102b061b2715" => :mojave
    sha256 "2a207a17f9948055db758ec32d231a909cc24611e9e58dfdffa6933ba39bf4fd" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gst-plugins-base"
  depends_on "gstreamer"

  def install
    args = std_meson_args + %w[
      -Dintrospection=enabled
      -Dtests=disabled
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{bin}/ges-launch-1.0", "--ges-version"
  end
end
