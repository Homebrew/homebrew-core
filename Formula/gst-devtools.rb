class GstDevtools < Formula
  include Language::Python::Shebang

  desc "GStreamer development and validation tools"
  homepage "https://gstreamer.freedesktop.org/modules/gstreamer.html"
  url "https://gstreamer.freedesktop.org/src/gst-devtools/gst-devtools-1.22.0.tar.xz"
  sha256 "4d21fee5c15f2877c0b1f6c2da0cdba67ce7caab2c199ab27e91a1394d5ba195"
  license "LGPL-2.1-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-devtools.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-devtools/"
    regex(/href=.*?gst-devtools[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "fcbd0823c79339f93fd0beaecf2edd2c8865fd4861ed707e0cd2575385eab23f"
    sha256 arm64_monterey: "98d37761162ed0ff37afa62f86c2e56045f09847153490ce14c79ad22d6f4e51"
    sha256 arm64_big_sur:  "91cd476c3f601516584333d01f7bdd449efb296fa6b7609468502393af2f3b97"
    sha256 ventura:        "1c71376517f5b816a396e6e6efb812191e269f1646b44ac116a347d59854a121"
    sha256 monterey:       "c1eb2b68e7fa3997d1dd7970ea58af418bb6d802ec75196c915f47ee128b49fb"
    sha256 big_sur:        "66b4bbc01e35abe21bd8687540d00b1d14517419b8ed4f3b152d5e4e753bda3e"
    sha256 x86_64_linux:   "0fbe200e9fd1c563d4407a52b949ddb5786a4afb33cde3d3cfdc3a8b4b9b9d4a"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "gstreamer"
  depends_on "json-glib"
  depends_on "python@3.11"

  def install
    args = %w[
      -Dintrospection=enabled
      -Dvalidate=enabled
      -Dtests=disabled
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    rewrite_shebang detected_python_shebang, bin/"gst-validate-launcher"
  end

  test do
    system bin/"gst-validate-launcher", "--usage"
  end
end
