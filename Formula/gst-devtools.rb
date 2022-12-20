class GstDevtools < Formula
  include Language::Python::Shebang

  desc "GStreamer development and validation tools"
  homepage "https://gstreamer.freedesktop.org/modules/gstreamer.html"
  url "https://gstreamer.freedesktop.org/src/gst-devtools/gst-devtools-1.20.4.tar.xz"
  sha256 "82a293600273f4dd3eed567aae510ca0c7d629c3807788b00e6cdbd1d2459a84"
  license "LGPL-2.1-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-devtools.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-devtools/"
    regex(/href=.*?gst-devtools[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "0fec4d236de24ba499dddd2018092b7f2fc60439cdc27ed9d77aef984d2a87bc"
    sha256 arm64_monterey: "e4a0eb6ab7925745026f99a8f2bf3d745ae76015a95c65a055fbf46d53b9df44"
    sha256 arm64_big_sur:  "f8358778a740398b86c986d0925b7b5a4a48f02f5d76d4ecaabe1f137cce971a"
    sha256 ventura:        "a9ba3d7cef7e1a85947a3c0ebca87b2b4661e43e551cc4a4092fd7f141e1e523"
    sha256 monterey:       "03a889e5e2fe120eca9a5d6d357d0ef5c202f9be3062eb72babf05c8660c026f"
    sha256 big_sur:        "d9d9dc454cd16a15fc34fc31d8e5b06cb686ed4e6452034d9386b6cfafd57c10"
    sha256 x86_64_linux:   "ae8f07845490d890bf1b76eb8f7e6daaf717724cfd54e92247c811370d585a36"
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
