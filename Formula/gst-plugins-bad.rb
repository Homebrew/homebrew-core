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
    sha256 arm64_ventura:  "da24f02ddefa2a782816c9d548f3105aabd048752e845d03cdb01e8e9f236ae2"
    sha256 arm64_monterey: "5d1562a4d0c2ee784434dd24c7cdf091e5425277bc13354b9d50f750d8c77392"
    sha256 arm64_big_sur:  "3a122b127e1c1af4e093fbb937ae9bb90900e332f9ef95de0cf49c8206f7e294"
    sha256 ventura:        "08e833950120afbd48f03baeba86e2e82bb8b97ac845fc23610833019cf5514e"
    sha256 monterey:       "1f294a19d4398027ed47db49f3778984e9d32424a9d79cadcd6b421782c047b2"
    sha256 big_sur:        "1a48a2a49831cd0566f9ddbb73e469b87d49bef8f719e05b4fb9149121eba3b3"
    sha256 x86_64_linux:   "575b25a7fb0011521bb80b67b3c5b0ddc70486023c99164cb08519538f6b4ee1"
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
