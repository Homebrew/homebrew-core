class GstDevtools < Formula
  include Language::Python::Shebang

  desc "GStreamer development and validation tools"
  homepage "https://gstreamer.freedesktop.org/modules/gstreamer.html"
  url "https://gstreamer.freedesktop.org/src/gst-devtools/gst-devtools-1.20.0.tar.xz"
  sha256 "69fc8756ec9d93e5c5258c99088434f203e91fdbc5af28d1f2c583fd819b7a1d"
  license "LGPL-2.1-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-devtools.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-devtools/"
    regex(/href=.*?gst-devtools[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "dbfdd09bb918e3fbe4df2c93141a7543e8ad71523bddf244c7e02aa9f86fb32e"
    sha256 arm64_big_sur:  "c14e530f942070ab7693c4e0580736e8dadae3112c1e2beddf396cf852cdddc6"
    sha256 monterey:       "251eba4493f8165ea9f389806951517194a603597a48d58a206582e52bab4183"
    sha256 big_sur:        "3645c1d620984983e11d4e4f35ad94ad4dd113a8c011e6c27b925116270a2866"
    sha256 catalina:       "0ecb1a377906fd2eb1595dd755b72b21d475d5ab2861a25925b61f5939e9eeaa"
    sha256 x86_64_linux:   "6d5f9c2e9d45ab4276161c07571cd7a6f3fe01610592632a07a75d7e9cbdcc6e"
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
