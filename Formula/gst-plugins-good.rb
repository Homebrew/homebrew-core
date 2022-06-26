class GstPluginsGood < Formula
  desc "GStreamer plugins (well-supported, under the LGPL)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.20.3.tar.xz"
  sha256 "f8f3c206bf5cdabc00953920b47b3575af0ef15e9f871c0b6966f6d0aa5868b7"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-good.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-good/"
    regex(/href=.*?gst-plugins-good[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "8dffe0671dac26808499922c3b0755836c8e28d14ff3d1c52b9c7a2c87c67ef9"
    sha256 arm64_big_sur:  "5fd561f27b7eb60ccad37e7f873f3eddd00189bdfcb6a1c7d89bd950cef8a340"
    sha256 monterey:       "3b9f245f27bdf0cbfe5e316f35ad432fda7149c948249384b88d4aa5a073ac71"
    sha256 big_sur:        "629e751fc6324db7106be93113f14bf4aed0a4ff50f583ff7680e30aaf3e398e"
    sha256 catalina:       "ae77c2e72bbe730a5b3dba3cf5c17e0668b9b6423add4e91ac379d7f44544c7d"
    sha256 x86_64_linux:   "efe269615e2779bfc42de7564cb2cf166095527f21d0d1db469cee490a19e1fd"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "flac"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "gtk+3"
  depends_on "jpeg"
  depends_on "lame"
  depends_on "libpng"
  depends_on "libshout"
  depends_on "libsoup"
  depends_on "libvpx"
  depends_on "orc"
  depends_on "speex"
  depends_on "taglib"

  def install
    args = std_meson_args + %w[
      -Dgoom=disabled
      -Dximagesrc=disabled
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin cairo")
    assert_match version.to_s, output
  end
end
