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
    rebuild 1
    sha256 arm64_ventura:  "2a9dfdea5613377e9272d1146bc19fee42d4e4b19aef3c3ebc66e7758e0304fd"
    sha256 arm64_monterey: "90ab8d052e4e604af92c6f2da16c39d59edbeeb4c71468ed1f28baf5c5d25ef8"
    sha256 arm64_big_sur:  "906df89626b77a02736354b57fea8a18cc5d66c2038fe18927a6248c39c2aa7a"
    sha256 ventura:        "e001bb2b9450f7f5d9a30aee380ab520380fef5951449a7fb433db5bcb19e024"
    sha256 monterey:       "6789a1ac8072824a179b5fe0d090e6af1c5c176a17bdd9ce12f4d170cffadc57"
    sha256 big_sur:        "c32730a1408b72b32f3ec0cf4f935ad17496d455fdc9467ecf3b61c1acc99634"
    sha256 catalina:       "e01365b988dd0b6f39c26b923978aeb9964e786489699fcffa857ac6d6da9cb0"
    sha256 x86_64_linux:   "5afbb446595a497628aa384ef46504859db70fdfef9c1d28fbf15064c8502ff4"
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
