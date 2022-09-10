class GstPluginsGood < Formula
  desc "GStreamer plugins (well-supported, under the LGPL)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.20.3.tar.xz"
  sha256 "f8f3c206bf5cdabc00953920b47b3575af0ef15e9f871c0b6966f6d0aa5868b7"
  license "LGPL-2.0-or-later"
  revision 2
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-good.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-good/"
    regex(/href=.*?gst-plugins-good[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "843f786682e0838948787af9e334f78200e69e6aa029555b14ab784eadbbeae5"
    sha256 arm64_big_sur:  "0add3160d6455fef21ce06aa8ec72b3211701ff053c30cd9d5d326f63cf78b4f"
    sha256 monterey:       "97a73d2e1517c8b4a14cfcacd99cfc37bc0b51ac73e6d3d45e268aa26f6b500f"
    sha256 big_sur:        "548d976418b0674c3bfae090dfdf95caf81265ed28d8f805581969c87bdf5969"
    sha256 catalina:       "8af212934a8a49b17608ab23867c199ae8dc8b20ec34c16fadb18fbd484688bf"
    sha256 x86_64_linux:   "17eaf185e0943aa1c8b4fc1a270ba0ca76dac7a65f8edf27ca8ad6e744e94b53"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "flac"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "gtk+3"
  depends_on "jpeg-turbo"
  depends_on "lame"
  depends_on "libpng"
  depends_on "libshout"
  depends_on "libsoup"
  depends_on "libvpx"
  depends_on "orc"
  depends_on "speex"
  depends_on "taglib"

  def install
    system "meson", *std_meson_args, "build", "-Dgoom=disabled", "-Dximagesrc=disabled"
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin cairo")
    assert_match version.to_s, output
  end
end
