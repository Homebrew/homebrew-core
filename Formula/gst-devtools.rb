class GstDevtools < Formula
  include Language::Python::Shebang

  desc "GStreamer development and validation tools"
  homepage "https://gstreamer.freedesktop.org/modules/gstreamer.html"
  url "https://gstreamer.freedesktop.org/src/gst-devtools/gst-devtools-1.18.5.tar.xz"
  sha256 "fecffc86447daf5c2a06843c757a991d745caa2069446a0d746e99b13f7cb079"
  license "LGPL-2.1-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-devtools.git"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-devtools/"
    regex(/href=.*?gst-devtools[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "98d8f50b933ba73a496c847bf8468a9703766cfc33de874c1025627a85a81318"
    sha256 arm64_big_sur:  "f80540ba393407aceb95c070461ad5ebbbb9bd9869e9148777350657d6491cfa"
    sha256 monterey:       "140957153cd0d4b572e10820ebd22f1ea60793b7baeabf20776dda7419644cd4"
    sha256 big_sur:        "d592155862275fb39caccda2a52faee2478755fdf3c44f63cf43043cc823a2ca"
    sha256 catalina:       "a3867172205b79066778fc3b0337b569bbdf44c4d7c21e51720d10f0af070da9"
    sha256 mojave:         "10ca693d40baa57b6c8c161923de066c23f1fbba9004ba7106cfa09739effe8f"
    sha256 x86_64_linux:   "e5cd968f9cdf62927fd3054ca7205e79470a3ac11109bccc15dd89d5cab5dedd"
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
