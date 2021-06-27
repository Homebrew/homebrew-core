class GstDevtools < Formula
  include Language::Python::Shebang

  desc "GStreamer development and validation tools"
  homepage "https://gstreamer.freedesktop.org/modules/gstreamer.html"
  url "https://gstreamer.freedesktop.org/src/gst-devtools/gst-devtools-1.18.4.tar.xz"
  sha256 "ffbd194c40912cb5e7fca2863648bf9dd8257b7af97d3a60c4fcd4efd8526ccf"
  license "LGPL-2.1-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-devtools.git"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-devtools/"
    regex(/href=.*?gst-devtools[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "8eb42ba8a37c3148ddb08bac4f6da532079cfd2b48f7a60fee705ba553eaa533"
    sha256 big_sur:       "c9112da83d65e0993e5b5ce4a87ae72e85093c57ad21c7b99e52a69cc36a8b1a"
    sha256 catalina:      "b01a80a014c19658e7a3d8b3a8f54db3f98bec9314ba887690b632a28b492fbb"
    sha256 mojave:        "4537802ab817fc7b4c74f9968363bec97aafdabc8439935fc905dc46dd473a60"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "gstreamer"
  depends_on "json-glib"
  depends_on "python@3.9"

  def install
    args = std_meson_args + %w[
      -Dintrospection=enabled
      -Dvalidate=enabled
      -Dtests=disabled
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    rewrite_shebang detected_python_shebang, bin/"gst-validate-launcher"
  end

  test do
    system "#{bin}/gst-validate-launcher", "--usage"
  end
end
