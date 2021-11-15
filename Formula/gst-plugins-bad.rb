class GstPluginsBad < Formula
  desc "GStreamer plugins less supported, not fully tested"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.18.4.tar.xz"
  sha256 "74e806bc5595b18c70e9ca93571e27e79dfb808e5d2e7967afa952b52e99c85f"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad.git"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/"
    regex(/href=.*?gst-plugins-bad[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "ca8586eaf948a1b1d5c3e56fa258fd3098764f81d5bef1c622324aaedec53695"
    sha256 arm64_big_sur:  "6c0ada7dac8defafc4e6d099870d22efd9cae93ef4c7afce32684e2d62dbb674"
    sha256 monterey:       "c591057877a706e583a293a858553cf26ed3a8346dd37bfeaf2bab39b9d11daa"
    sha256 big_sur:        "c4c7f8121511f8981dd7478d81ef8a773fab0c714b820ecbbfdfb56d71ccf737"
    sha256 catalina:       "bb4a58be9dd95562605a8a7537eedcdb76ec4671eaebe8fdda4416b1a67b5621"
    sha256 mojave:         "fa30f63fdccd9d97dd43612582b5fb32952f33ae1f7eac26b506fefe64a2f39b"
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
  depends_on "libmms"
  depends_on "libnice"
  depends_on "libusrsctp"
  depends_on "musepack"
  depends_on "openssl@1.1"
  depends_on "opus"
  depends_on "orc"
  depends_on "rtmpdump"
  depends_on "srtp"

  def install
    args = std_meson_args + %w[
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
