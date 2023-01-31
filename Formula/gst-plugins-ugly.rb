class GstPluginsUgly < Formula
  desc "Library for constructing graphs of media-handling components"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.22.0.tar.xz"
  sha256 "a644dc981afa2d8d3a913f763ab9523c0620ee4e65a7ec73c7721c29da3c5a0c"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-ugly.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/"
    regex(/href=.*?gst-plugins-ugly[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "34c97fe5f82fae715914e162829e116f1358214c2d41acba38c0be75d7ddf7b3"
    sha256 arm64_monterey: "70b6ffb43edbaebaadd7f866436770fc6c72b618e3dbf143c244814b76136ccd"
    sha256 arm64_big_sur:  "c4028b00d652a69a8808a7ed52f120f4be4162bc61027eb304e146ea85d2aa45"
    sha256 ventura:        "93034803df9578a2aec65e6e73f75ed457792f4580736b4059edba70def940ce"
    sha256 monterey:       "63097dcec77f9af54cab001fde7d5125b00c11485188352091ae7f0507e7355e"
    sha256 big_sur:        "931acd6a551ebc858f45412499581ee82669c508c7c44c353d007bd040520ee3"
    sha256 x86_64_linux:   "55a17f3e3fa9da3de4d1af0ae204c4e886f3dda9e6223af012a25f34219ee657"
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
