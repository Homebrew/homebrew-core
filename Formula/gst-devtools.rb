class GstDevtools < Formula
  include Language::Python::Shebang

  desc "GStreamer development and validation tools"
  homepage "https://gstreamer.freedesktop.org/modules/gstreamer.html"
  url "https://gstreamer.freedesktop.org/src/gst-devtools/gst-devtools-1.18.3.tar.xz"
  sha256 "3025fee3607caf5069154c099533785675916e044ee92c936bbeacdda3750f26"
  license "LGPL-2.1-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-devtools.git"

  bottle do
    sha256 "4c90295c25a0601c35262ee438eaaf9693cc0beb879fa8caab7c30be4115064c" => :big_sur
    sha256 "a3662cb83ba270a922c7d9c24567583ed71554519f4f9e763c29d2a3ffbbd82a" => :arm64_big_sur
    sha256 "51eca8aaf936f56140cc632f242a3124e49c4a9fcb8b44f5ae5eaf25e7936bfa" => :catalina
    sha256 "2bc663d80768ec5c2b2ddcbbc689eea373179d2a8388f093dc2b90232fd31653" => :mojave
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
