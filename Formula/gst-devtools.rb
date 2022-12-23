class GstDevtools < Formula
  include Language::Python::Shebang

  desc "GStreamer development and validation tools"
  homepage "https://gstreamer.freedesktop.org/modules/gstreamer.html"
  url "https://gstreamer.freedesktop.org/src/gst-devtools/gst-devtools-1.20.5.tar.xz"
  sha256 "5684436121b8bae07fd00b74395f95e44b5f26323dce4fa045fa665676807bba"
  license "LGPL-2.1-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-devtools.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-devtools/"
    regex(/href=.*?gst-devtools[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "e859091dd0314ec5ac9615e93b3f989b925e385112c80756de54880f55addb2e"
    sha256 arm64_monterey: "34bc999c3ec0b285638aefcbfcb09c91dac1970522b2360264a182d7696cf530"
    sha256 arm64_big_sur:  "87c2d002078bb392b1e8e84744490fa9e1e23d338b76d394dc1be3073d771ef4"
    sha256 ventura:        "18865d7967560dc7a01177e72adcf09824549dea709e9489cd6eee6e4dc3754b"
    sha256 monterey:       "7d241f7159010d90dd0ecf27595f2f34e90f0ae2e8c31afc1422967e6413ce30"
    sha256 big_sur:        "57671b39b02280e4f57fd784d8868569f19e6f5d392ad94a6d6b2a105d898b80"
    sha256 x86_64_linux:   "00a51ad101b5b16c07310b628787704fac546e48218d1e12161076c5be622a03"
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
