class GstDevtools < Formula
  include Language::Python::Shebang

  desc "GStreamer development and validation tools"
  homepage "https://gstreamer.freedesktop.org/modules/gstreamer.html"
  url "https://gstreamer.freedesktop.org/src/gst-devtools/gst-devtools-1.20.2.tar.xz"
  sha256 "b28dba953a92532208b30467ff91076295e266f65364b1b3482b4c4372d44b2a"
  license "LGPL-2.1-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-devtools.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-devtools/"
    regex(/href=.*?gst-devtools[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "f88fe91cf8fc01aa5fd3b71840ed4d7bfea984b68e0071072d861083f18e8fa3"
    sha256 arm64_big_sur:  "5e3fdcd871ce4acf136a156e83d5412737f3a94ed8222e7dc14abc18938625c4"
    sha256 monterey:       "e35bc7ecf64c396edadd228680bab05cbb53ad77c6d84d8fddf21a77532eddbd"
    sha256 big_sur:        "daace8f7b0f9a5651304559f881db806fa48455052ba6f5938668d82c1292ab3"
    sha256 catalina:       "fb0a20990ffa13dbf2fe25d56e4b5c594cfffcc09eb7c5f9dc0052ecb684f6df"
    sha256 x86_64_linux:   "6ba66b31f51f1bb0d67d129f6999f88c05d27ca08bd39e7f7097b5d0c6baaaa9"
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
