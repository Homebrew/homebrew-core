class GstPluginsBad < Formula
  desc "GStreamer plugins less supported, not fully tested"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.20.5.tar.xz"
  sha256 "f431214b0754d7037adcde93c3195106196588973e5b32dcb24938805f866363"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/"
    regex(/href=.*?gst-plugins-bad[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "13012d1dfac3c35da2601cdf180880f5a20c11a551165cb8989c82498843f928"
    sha256 arm64_monterey: "0a46011e1de12c199ef9f29434e0ac698433897eb900b72e09f70d6b0cd0293e"
    sha256 arm64_big_sur:  "78ef0269fbac8bcdf0820965ecdbac3fea4bdece2c5b2746b45ea178cebe565b"
    sha256 ventura:        "15579ba1ed41f314c9f379b3ccedc7a651bfd0aec0e9d99b2cad761a7b314143"
    sha256 monterey:       "28391708147df30000e582400c19674d484273820b72be3c5838f6f2f67b50ab"
    sha256 big_sur:        "4d87ebee6c63ccca61b0b28f417b895e04c06e7156992b0d63c6bcc3a3ccc02b"
    sha256 x86_64_linux:   "808d72501644b31b57aaf50d5ef1751cde9cc860830d791c2dcf59bc65b2ab4c"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "faac"
  depends_on "faad2"
  depends_on "fdk-aac"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "jpeg-turbo"
  depends_on "libnice"
  depends_on "libusrsctp"
  depends_on "openssl@1.1"
  depends_on "opus"
  depends_on "orc"
  depends_on "rtmpdump"
  depends_on "srtp"

  uses_from_macos "python" => :build, since: :catalina

  on_macos do
    # musepack is not bottled on Linux
    # https://github.com/Homebrew/homebrew-core/pull/92041
    depends_on "musepack"
  end

  def install
    # Plugins with GPL-licensed dependencies: faad
    args = %w[
      -Dgpl=enabled
      -Dintrospection=enabled
      -Dexamples=disabled
    ]
    # The apple media plug-in uses API that was added in Mojave
    args << "-Dapplemedia=disabled" if MacOS.version <= :high_sierra

    system "meson", *std_meson_args, "build", *args
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin dvbsuboverlay")
    assert_match version.to_s, output
    output = shell_output("#{gst} --plugin fdkaac")
    assert_match version.to_s, output
  end
end
