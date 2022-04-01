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
    sha256 arm64_monterey: "ef4d873d1b65c869a9a8e5f05e9aad67649ae723e7c92a603320b52de6d1a716"
    sha256 arm64_big_sur:  "a2999c158fd3e700426a328fd25991238a356828cffd956cb750715468985fe5"
    sha256 monterey:       "07e4e7b82bf4d1bde54ceb936c868c1e6d0e5e8bb1c8b5d03f5070a383b2bdf7"
    sha256 big_sur:        "befb557a42506d1a1278c3d069f42bda21da6d97825a9077443d7820ee7118f2"
    sha256 catalina:       "cf358fc19131d6b1ddca74d79fc2c777d034e6d7062547d9594ca8d5d5a78d61"
    sha256 x86_64_linux:   "f8258055d1c17aeb617e6e8d9167a298022ad51f3702f2bc08e7c2aa8441d678"
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
