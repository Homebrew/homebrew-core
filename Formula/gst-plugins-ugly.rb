class GstPluginsUgly < Formula
  desc "Library for constructing graphs of media-handling components"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.20.2.tar.xz"
  sha256 "b43fb4df94459afbf67ec22003ca58ffadcd19e763f276dca25b64c848adb7bf"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-ugly.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/"
    regex(/href=.*?gst-plugins-ugly[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b47b114074a08d06a74f9a76c8fbfc3825192be31b5ff6fdd95af8ffdb5d7c30"
    sha256 arm64_big_sur:  "67aeb5a674489a7423c2f62f76cb12d201ec1ed30ad23a52274c6d53da6931bb"
    sha256 monterey:       "33a3b85a1e514d2670d72116e15e54ff86254e8175cafe9975d4f37652ca5d04"
    sha256 big_sur:        "e6e5c6a2af088b4e984680955d640a5de859562cb8998082cd3167083f8b1ece"
    sha256 catalina:       "b2dc01ccf29be35afa8d72d860b5f12381584e304c65c1517a20e7264fbae5bb"
    sha256 x86_64_linux:   "5946f500bd61be2acf7c06f3e1be12d01adbd9767f06ab2ca26d95ff04563174"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "jpeg"
  depends_on "libshout"
  depends_on "libvorbis"
  depends_on "pango"
  depends_on "theora"
  depends_on "x264"

  def install
    # Plugins with GPL-licensed dependencies: x264
    args = std_meson_args + %w[
      -Dgpl=enabled
      -Damrnb=disabled
      -Damrwbdec=disabled
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin dvdsub")
    assert_match version.to_s, output
    output = shell_output("#{gst} --plugin x264")
    assert_match version.to_s, output
  end
end
