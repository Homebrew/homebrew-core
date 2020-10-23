class GstDevtools < Formula
  include Language::Python::Shebang

  desc "GStreamer development and validation tools"
  homepage "https://gstreamer.freedesktop.org/modules/gstreamer.html"
  url "https://gstreamer.freedesktop.org/src/gst-devtools/gst-devtools-1.18.0.tar.xz"
  sha256 "82337141b5654f11c440f783892ba9d9498b3b6b98c2286b000f96dce6945f16"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://anongit.freedesktop.org/git/gstreamer/gst-devtools.git"

  bottle do
    sha256 "9deffbd51968295db502d9ae7874f83458458c163daa427fba0451a6fed47bb5" => :catalina
    sha256 "a958772618d4b35b5a05fbacb9aee801c2d26b1e11e30270197f19abb83a08ea" => :mojave
    sha256 "d5a3e6fcbe0d7454574a0029925e103aa70e96db2235341c3e4bb7d1e81553ef" => :high_sierra
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
