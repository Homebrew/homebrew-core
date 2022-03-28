class GstPluginsBad < Formula
  desc "GStreamer plugins less supported, not fully tested"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.20.1.tar.xz"
  sha256 "09d3c2cf5911f0bc7da6bf557a55251779243d3de216b6a26cc90c445b423848"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/"
    regex(/href=.*?gst-plugins-bad[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "56b5ff67223daa651c1157a5c33c2228f41d1a93ea75953a5fc109e63b224d6d"
    sha256 arm64_big_sur:  "01395a5c550a59c5d0f0a9ff5cb3546031af73b532a16dd3637751bfb69e528b"
    sha256 monterey:       "35f133ea38f3e6e97a3303c88a94ee62d0962005b7c49dd0f1471c82965cf814"
    sha256 big_sur:        "a69ab37a044c5bb73023da346721e51e5f3d3185b333747b2ecfb5d5e25df930"
    sha256 catalina:       "aa3184252ca45b09c5326d704913fc637dff98c759ae6cb9b586278724bdf99e"
    sha256 x86_64_linux:   "971a6c9d18c23d128875f94d292607f988c1f4399b70e5c69c6245dde37ded88"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "faac"
  depends_on "faad2"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "jpeg"
  depends_on "libnice"
  depends_on "libusrsctp"
  depends_on "openssl@1.1"
  depends_on "opus"
  depends_on "orc"
  depends_on "rtmpdump"
  depends_on "srtp"

  on_macos do
    # musepack is not bottled on Linux
    # https://github.com/Homebrew/homebrew-core/pull/92041
    depends_on "musepack"
  end

  def install
    # Plugins with GPL-licensed dependencies: faad
    args = std_meson_args + %w[
      -Dgpl=enabled
      -Dintrospection=enabled
      -Dexamples=disabled
    ]

    # The apple media plug-in uses API that was added in Mojave
    args << "-Dapplemedia=disabled" if MacOS.version <= :high_sierra

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin dvbsuboverlay")
    assert_match version.to_s, output
  end
end
