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
    sha256 arm64_monterey: "d5b04612f32ad4a8864a85f760ac35f32198451105bb3e40c3cbe4f13c443f2c"
    sha256 arm64_big_sur:  "5b461d72973b6b7ecc1c965fe9f15736e71a1b44090bd37a636bf8caad60080a"
    sha256 monterey:       "779b3f85e3a1c01701226556ebc2c8d47d3049d63d6e3b33e8df8aed1c7724cf"
    sha256 big_sur:        "0f0b65caace74c66f89237416b872d9bd6e329edb7604f1523869d6d9d6517d5"
    sha256 catalina:       "cb0501d73a7b280411e37da5f37b5453c0eabe9ebb570137d12d962191ca7c34"
    sha256 x86_64_linux:   "78be42d6e58ea96f538018396a948aebf3e68a751a1f3a12b64621d85e9cde31"
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
