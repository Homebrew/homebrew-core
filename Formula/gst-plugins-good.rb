class GstPluginsGood < Formula
  desc "GStreamer plugins (well-supported, under the LGPL)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.20.2.tar.xz"
  sha256 "83589007bf002b8f9ef627718f308c16d83351905f0db8e85c3060f304143aae"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-good.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-good/"
    regex(/href=.*?gst-plugins-good[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "1fbd7cb8bc38c815fa4e447471334ad27098f8deaecbbf7e16a551d5ae1a112b"
    sha256 arm64_big_sur:  "b23be06b2b64ad19d7a808b409b7e532569e278af33aaca361bc3e2bff001e34"
    sha256 monterey:       "eac81976959dde1b90bfaf3b0012af1ee206cf0bcc2a84cbc14b2562a08910ab"
    sha256 big_sur:        "977c9483682a601ffd06173b1280274e286db73db2b4362ae32fbe52ea63ba0f"
    sha256 catalina:       "a0edcf967bb78481a48ee656be3bd4fd1b04b6e21e7bc25ac091a2640545f8be"
    sha256 x86_64_linux:   "b6d3fc8f6aade4a7cb96846031bd8d51adfcb107af471d7beac8af40b27f10a3"
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
