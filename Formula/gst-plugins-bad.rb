class GstPluginsBad < Formula
  desc "GStreamer plugins less supported, not fully tested"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.20.3.tar.xz"
  sha256 "7a11c13b55dd1d2386dd902219e41cbfcdda8e1e0aa3e738186c95074b35da4f"
  license "LGPL-2.0-or-later"
  revision 1
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/"
    regex(/href=.*?gst-plugins-bad[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "883e428e0916301e1ee4b21e041372a2b523f5e66ec649f6e1a7d073639878f9"
    sha256 arm64_big_sur:  "bdd8b41d13f8c98b863f0ca559881c7e4532e9845ac4aaf8a4951d9259f5117b"
    sha256 monterey:       "19fb8cc5efdccea94dd4574eac1e35da2a46b2ca6f48278b3a06d01385c0b8aa"
    sha256 big_sur:        "92107bb45bd7256d49cd09f2bcd56906f2942c8ff29728ced7ff50963030e84b"
    sha256 catalina:       "c2f67922be2cb4bea0c6606b9a4a144d2deba28277fdc47a1a1aabe2cc80dacd"
    sha256 x86_64_linux:   "669d27f5ea32b0cb17da5ca723e537ef0c68110bc5300140e158d3d386eb158e"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "faac"
  depends_on "faad2"
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
  end
end
