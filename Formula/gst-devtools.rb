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
    sha256 "f9f4c3b56900451560a484f7f08f566bb34c17b1bf63c32d8653851e7afe0f4c" => :catalina
    sha256 "b38054091a5c0156951daa97288e4b6728b768774e6e479111cc3d75373f0fa8" => :mojave
    sha256 "0c0d08f61c6c4a5589146edbdcb702831d7942c0a37b6bf64b22a30bab950828" => :high_sierra
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
