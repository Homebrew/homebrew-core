class GstPluginsUgly < Formula
  desc "Library for constructing graphs of media-handling components"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.18.4.tar.xz"
  sha256 "218df0ce0d31e8ca9cdeb01a3b0c573172cc9c21bb3d41811c7820145623d13c"
  license "LGPL-2.0-or-later"
  revision 1
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-ugly.git"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/"
    regex(/href=.*?gst-plugins-ugly[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "74c50e6cf754608da7ae14b0201b99a08a1e5b34ddbc32afa854af463ba21bc7"
    sha256 arm64_big_sur:  "93577cdbd18ee2cbdf026104ad07e9c9ae510c28a487a5fe4fbb18743ff596e8"
    sha256 monterey:       "838ab9145393003b51a80892a3c91083d2f15a5eaef93f58bd8a7599d74dfbef"
    sha256 big_sur:        "0a6d18fa102bcea7e8e096a8b114fa415a32c2c6cd477fdaa68255ffb119ac28"
    sha256 catalina:       "3bf8b148e0901057104047b7392c501986096858e287cc4f11299933f1708931"
    sha256 mojave:         "beb6b703ebad1a546c0ca4a9e9253e20bdb78c3aeba4231fdd1a645ab8fd11dc"
    sha256 x86_64_linux:   "4793a5155acb669f37d6e29f4fc48470b9f7ac8bb9332f9cfbba6a53e372f617"
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
