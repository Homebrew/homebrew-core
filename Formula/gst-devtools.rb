class GstDevtools < Formula
  include Language::Python::Shebang

  desc "GStreamer development and validation tools"
  homepage "https://gstreamer.freedesktop.org/modules/gstreamer.html"
  url "https://gstreamer.freedesktop.org/src/gst-devtools/gst-devtools-1.20.1.tar.xz"
  sha256 "81f1c7ef105b8bdb63412638952f6320723b3161c96a80f113b020e2de554b2b"
  license "LGPL-2.1-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-devtools.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-devtools/"
    regex(/href=.*?gst-devtools[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "85bb05c1db6998be46cba38553a2e6bb927ad60ed19b8ce30911ec7f51f8485e"
    sha256 arm64_big_sur:  "77feff22b2086ace82aaae718193ce19d3fcfa3d2e219261657c7979fa476e10"
    sha256 monterey:       "f273a16e34ed7bbd82c44dd12c7d88d90aa932a50a4e7bd8de4d3d4e6edbde7c"
    sha256 big_sur:        "a50de3e785f7301416361781c75c0a9d33d3c400da72ab341319a96067711ce2"
    sha256 catalina:       "a5241b12230fbd975c272e8f38168a4f34d1fffc0d02eb39d310b2d3d3f96939"
    sha256 x86_64_linux:   "db29b54d255505aa5f801baf1ba3896c159deaeb7b719a77dc9a0f3ed28cbb67"
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
