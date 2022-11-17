class GstPluginsGood < Formula
  desc "GStreamer plugins (well-supported, under the LGPL)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.20.3.tar.xz"
  sha256 "f8f3c206bf5cdabc00953920b47b3575af0ef15e9f871c0b6966f6d0aa5868b7"
  license "LGPL-2.0-or-later"
  revision 2
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-good.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-good/"
    regex(/href=.*?gst-plugins-good[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "3b4ffd9777e053e50730ede8b2198da1f231d504a2d03d78068127e11eadaeb0"
    sha256 arm64_monterey: "1e1f7fce251966cd64595eb91954a281c9678bd33ff247fcc876d2ea7e2b31ef"
    sha256 arm64_big_sur:  "7488f78b9591614a476f42ed065a7a5f238826c5ac941dab6b0dafda70fa7e98"
    sha256 ventura:        "7fb92551a36943723ab8eb533b79d59dd75cdd78885836f74e2fbf9577415317"
    sha256 monterey:       "61d30e5fda5a9a6f9b711eaa085d67e2df36186729fc4aada108fdf2fac165de"
    sha256 big_sur:        "fabb7836a584cde7ea86aa4214201375a5066d93d9a78b9f9a7a07cc4c0f4a5a"
    sha256 catalina:       "85d8b5ed3db4ddba06afb4e2a817255c0fedd64ad18f1b8a66b30089896e890a"
    sha256 x86_64_linux:   "0c7665a781a49a80548e4a186ff895ebd2d6a35a9f03a62936e54d739127d110"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "flac"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "gtk+3"
  depends_on "jpeg-turbo"
  depends_on "lame"
  depends_on "libpng"
  depends_on "libshout"
  depends_on "libsoup"
  depends_on "libvpx"
  depends_on "orc"
  depends_on "speex"
  depends_on "taglib"

  def install
    system "meson", *std_meson_args, "build", "-Dgoom=disabled", "-Dximagesrc=disabled"
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin cairo")
    assert_match version.to_s, output
  end
end
