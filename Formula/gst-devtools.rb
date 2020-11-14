class GstDevtools < Formula
  include Language::Python::Shebang

  desc "GStreamer development and validation tools"
  homepage "https://gstreamer.freedesktop.org/modules/gstreamer.html"
  url "https://gstreamer.freedesktop.org/src/gst-devtools/gst-devtools-1.18.1.tar.xz"
  sha256 "712212babd2238233d55beecfc0fe1ea8db18e8807ac6ab05a64505b2c7ab0df"
  license "LGPL-2.1-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-devtools.git"

  bottle do
    sha256 "4befaddc224b6621effeed0b92e336b6ec6cc8ea2be44fb5ccfe681561d7509b" => :catalina
    sha256 "fbca18af1a8412f2a58ca7c3b0166e3e2019b1673ec493c252ae522c3094ad14" => :mojave
    sha256 "0eb56251926b5ecc220708f8da188d1585473dfbd59a629d8a8351a971678f76" => :high_sierra
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
