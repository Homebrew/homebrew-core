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
    sha256 arm64_ventura:  "091ed18cc17df1e34ce9fb8ccfc8525a2070639750641a78378d60498274d91a"
    sha256 arm64_monterey: "f2889ce34b419f4235223e90aacd1d2d2f0b0788818994d0a43eb928ee440bcb"
    sha256 arm64_big_sur:  "b8d6253e76065cfd072ac0504cacf61cdea1dc9d82369063ad0786ef85b8e999"
    sha256 ventura:        "1cdb37b6d96ddcb4c6c9ace5890a722746bff584cf78278282959cb9d1758ba0"
    sha256 monterey:       "fb1845a7bec55ca73f70b6a8ffe550a1d67ec1375317d918a04b48baa79d60b3"
    sha256 big_sur:        "508246f9e7d47930fdb7f39d4393c36ca43bacd9ed6651c3241583403c10a024"
    sha256 x86_64_linux:   "b6cd9460f8d8ac809bfb599d1a5151f794152aef4d1959264fdc3e839a9855c3"
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
