class GstPluginsBad < Formula
  desc "GStreamer plugins less supported, not fully tested"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.20.2.tar.xz"
  sha256 "4adc4c05f41051f8136b80cda99b0d049a34e777832f9fea7c5a70347658745b"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/"
    regex(/href=.*?gst-plugins-bad[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "f15b6a728bd5585b9072d9722003018b7a4a02f7289ce551a8857b8263dfe745"
    sha256 arm64_big_sur:  "011e4be1082018e55902a00d01855318ddf539b57619da0e238f0a57193ef618"
    sha256 monterey:       "e6c6cd613da25748e5289d3ef3fce248c3f39c71a148f93efc1322939c7f2a09"
    sha256 big_sur:        "4809f08c943bd75c13c528e0d0f947afa03b7c2aa18723465590df7efd9d7a66"
    sha256 catalina:       "eb0049f1f11166e45ff20ebc55ea2d2760273d79bbd70dcaad6dce01873a7a92"
    sha256 x86_64_linux:   "653f8cad7678ce1205c30ff0b4d43f0939b410e8797a9ab5ed9adbd33d346039"
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
