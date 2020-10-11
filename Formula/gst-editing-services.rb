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
    sha256 "54ee45634af1436dadc952ef3d5478036037cc3f85c97407b76f6eadc1f61ca6" => :catalina
    sha256 "8c6aafd9c9f555deb8bbfc660b1033977315a67a7572fd78aeb369d380547cec" => :mojave
    sha256 "d0d844da99e4bee0abdb7a7bd6dec5d235a3d0322cdff11a39d4058f2e6e8cbd" => :high_sierra
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
