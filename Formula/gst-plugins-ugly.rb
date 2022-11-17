class GstPluginsUgly < Formula
  desc "Library for constructing graphs of media-handling components"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.20.3.tar.xz"
  sha256 "8caa20789a09c304b49cf563d33cca9421b1875b84fcc187e4a385fa01d6aefd"
  license "LGPL-2.0-or-later"
  revision 1
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-ugly.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/"
    regex(/href=.*?gst-plugins-ugly[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "17fa16372fcc531145633e5e4c1be6b03dcf48da77670322e009bdff3d55f157"
    sha256 arm64_monterey: "67eac319f32b17de132ae2f3b9e87d64087aed757455405be80f749d56b0244d"
    sha256 arm64_big_sur:  "1985275d5911536e5690f0d8d0a3343706df8dabe5940d92b70abb7c1903b4e9"
    sha256 ventura:        "72e1d67aa0929074962269f13dbede212f9f7d54de3ece49abdcfdb9948767dd"
    sha256 monterey:       "df08cbde7e2cb994c58ee40f067e0b468942ef82a5cf6111bd40a5039da09e9e"
    sha256 big_sur:        "a5f3b672a2337ecba14e384e3a2711a1167dc30bbc8e811ff810c6f5c65e48d3"
    sha256 catalina:       "552b9feec549e978950f21280b5a1a5ed974d843b1d4c64bcacffed21f5fbfd4"
    sha256 x86_64_linux:   "a7fad973d69eb1e7978a3d269d1f60b8cb0874f9bda1be8f149ea3ae5424d810"
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
