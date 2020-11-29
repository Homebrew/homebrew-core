class GstPluginsUgly < Formula
  desc "Library for constructing graphs of media-handling components"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.18.1.tar.xz"
  sha256 "18cd6cb829eb9611ca63cbcbf46aca0f0de1dd28b2df18caa2834326a75ff725"
  license "LGPL-2.0-or-later"
  revision 2
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-ugly.git"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/"
    regex(/href=.*?gst-plugins-ugly[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "6b9873a83aa8abf05c00202db6598aca62ff62a152aa4a3ba4c3ad7d856187cc" => :big_sur
    sha256 "b0cff8eebb5a86764b5a370a5896d93aeb030907df7cb564fb20c5855843a3da" => :catalina
    sha256 "a6ba3f422f3d6b332e2159cdb752acc0a000b50611118301ad56dc4da614b045" => :mojave
    sha256 "decba1dff60ae4c0f40bf9530deb2d04eb20c09e72af0f70a12dea8c40a21d7d" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "jpeg"
  depends_on "libmms"
  depends_on "libshout"
  depends_on "libvorbis"
  depends_on "pango"
  depends_on "theora"
  depends_on "x264"

  def install
    args = std_meson_args + %w[
      -Damrnb=disabled
      -Damwrbdec=disabled
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
