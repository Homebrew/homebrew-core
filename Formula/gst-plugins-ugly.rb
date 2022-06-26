class GstPluginsUgly < Formula
  desc "Library for constructing graphs of media-handling components"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.20.2.tar.xz"
  sha256 "b43fb4df94459afbf67ec22003ca58ffadcd19e763f276dca25b64c848adb7bf"
  license "LGPL-2.0-or-later"
  revision 1
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-ugly.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/"
    regex(/href=.*?gst-plugins-ugly[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "359e021f1a9562fa08cb5761e375a3c446038d616d006630c4e81605d85b0e15"
    sha256 arm64_big_sur:  "319eb95fbedfca64981990d607b54f3b63f29bc51ed8e1113cc288887cf2858b"
    sha256 monterey:       "7aa5ab4cce4bf05e71eaac8366fc7f2f4fd290fa173f09f338eebfe908989e97"
    sha256 big_sur:        "8432a73e5821b0adae8c57eddfe97a57847ffe75ed053be37eb32b977e1da0dd"
    sha256 catalina:       "d53bfc418ab6bc4c4c4c3ed95b4cc4b14a384cbc45f635fd7592b31005d4ae52"
    sha256 x86_64_linux:   "3762e02c152a894571f83713ee6020c4c1cf5767c343bdf4b36083fcccdf6014"
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
