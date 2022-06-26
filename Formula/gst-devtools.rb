class GstDevtools < Formula
  include Language::Python::Shebang

  desc "GStreamer development and validation tools"
  homepage "https://gstreamer.freedesktop.org/modules/gstreamer.html"
  url "https://gstreamer.freedesktop.org/src/gst-devtools/gst-devtools-1.20.3.tar.xz"
  sha256 "bbbd45ead703367ea8f4be9b3c082d7b62bef47b240a39083f27844e28758c47"
  license "LGPL-2.1-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-devtools.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-devtools/"
    regex(/href=.*?gst-devtools[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "48e75b6fd3eb0be8f82bebc26de96d6f77f8d37739d068210d4b5adc79054f0e"
    sha256 arm64_big_sur:  "96ebc1423a9f90ca429c930fb1dbc1e5e45a7b0cdfc70852a0bfed293bee523e"
    sha256 monterey:       "b41daa5d52e150630f44ded58abe3bf03caba55de575eca117a8bf7818a64970"
    sha256 big_sur:        "63ca4d6f1e99dab7b3f4126bdf16b3892506a09e0073287b1f89a8e0814f093f"
    sha256 catalina:       "88b097af2ec90392de273acf3c9614c0a0fe438ea28d67d5c3245732d16be9ff"
    sha256 x86_64_linux:   "96b52680c3f8999abff8363a896924843c976937255d9f7223fcdb735278d359"
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
