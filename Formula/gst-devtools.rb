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
    sha256 arm64_ventura:  "fd54ccc7cff8566b374875d65899ef1a36913e1e4048bab2b74efe941f263994"
    sha256 arm64_monterey: "8e70edceb0d37d00142e838b23985f713f5a2893937ca77c3fa10907453c8d4e"
    sha256 arm64_big_sur:  "fbcc046496fa19f38210bebfef79d53e5073c775866316126f5bdea515ebaf73"
    sha256 ventura:        "79be9fb59c15220c5d6dc9ad978537883251f35fa2a17792f1c03fd18addacea"
    sha256 monterey:       "348827f557cab2431747a6387a3c5b647ab4cfb13b37886b45830bd0c094e9ab"
    sha256 big_sur:        "8ace31da36bac519db16469a83a180354d853968c9153c980aedec981dd2e187"
    sha256 x86_64_linux:   "4d5e361535caf26074c61d1615f57323c7a30cfb250f60b606afbed1dcb3dadb"
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
