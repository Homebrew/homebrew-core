class GstPluginsBad < Formula
  desc "GStreamer plugins less supported, not fully tested"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.22.0.tar.xz"
  sha256 "3c9d9300f5f4fb3e3d36009379d1fb6d9ecd79c1a135df742b8a68417dd663a1"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/"
    regex(/href=.*?gst-plugins-bad[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "010120213bd50f71eb9411a561905ca3d85a72a82591e0351273ec43bf797d9d"
    sha256 arm64_monterey: "96d634b448867d38c80d231df99bd01f586da79c09d115b4420fe4eb540e076a"
    sha256 arm64_big_sur:  "64fc75c767f6f4590cf0c44ccef5741d29bb1002002f076da6bc77053364ea08"
    sha256 ventura:        "95741a1736b7c311c1cadd4483d7c36af62723aac6a4319ca693ba260f7f5b6f"
    sha256 monterey:       "eef5c8bdce9a1da53386a2ec4b0bfe2f413598fc1465773c590b422b1106d1c3"
    sha256 big_sur:        "e62f6d626d28d1e3757a3048836fd723f53e19bc6c21cac08e82cb6ff130a98e"
    sha256 x86_64_linux:   "d1bf29fc40b493ab62a655377cc0c138786071a39bbbaf8b5bfefeab7caaeb81"
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
