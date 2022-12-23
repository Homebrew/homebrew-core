class GstPluginsUgly < Formula
  desc "Library for constructing graphs of media-handling components"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.20.5.tar.xz"
  sha256 "af67d8ba7cab230f64d0594352112c2c443e2aa36a87c35f9f98a43d11430b87"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-ugly.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/"
    regex(/href=.*?gst-plugins-ugly[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "a0fa9fdfe7351b91c95a06867d3bf9ad4ed9fb430f22ea74714780491325410d"
    sha256 arm64_monterey: "c43284925c6aebd34d6b4ad28e059f439ee36f7726ed20b6a1ba5f46e6e06e97"
    sha256 arm64_big_sur:  "ceec0f5b0d8bb5b206b0a81f82ae0b0675226edac29d411a96318473846910b8"
    sha256 ventura:        "a5a4aa5dd31cda87395341af1cfad05fdd2979746f7abcf34c9b9fc973093357"
    sha256 monterey:       "441b24bcdaa4ec0e5e3a0d4cb5e72a6524c2cd0ad4ba7a47aa2802303ffebd7f"
    sha256 big_sur:        "5650747163bdcb3bffe1f8eda81806e2c0f156f0853ec510b987fbb885978b2b"
    sha256 x86_64_linux:   "52401435d454ba67ed435d2fb505a7fdadba9bbe2c35b38eb7c3e928a276d743"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "jpeg-turbo"
  depends_on "libshout"
  depends_on "libvorbis"
  depends_on "pango"
  depends_on "theora"
  depends_on "x264"

  uses_from_macos "python" => :build, since: :catalina

  def install
    # Plugins with GPL-licensed dependencies: x264
    system "meson", *std_meson_args, "build",
                    "-Dgpl=enabled",
                    "-Damrnb=disabled",
                    "-Damrwbdec=disabled"
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin dvdsub")
    assert_match version.to_s, output
    output = shell_output("#{gst} --plugin x264")
    assert_match version.to_s, output
  end
end
