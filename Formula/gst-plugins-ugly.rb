class GstPluginsUgly < Formula
  desc "Library for constructing graphs of media-handling components"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.20.1.tar.xz"
  sha256 "42035145e29983308d2828207bb4ef933ed0407bb587fb3a569738c6a57fdb19"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-ugly.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/"
    regex(/href=.*?gst-plugins-ugly[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "c10bb4e208b4b0a365b11f5a1db6caa3f81d84bb7068d5d0531ba0c6ac84ab9f"
    sha256 arm64_big_sur:  "7850cc79f7a37e90ce45be14440a52129522846b84f78e073e3a7d3b8ed39fe9"
    sha256 monterey:       "2bfa4940846d3ab0ca62e185c168c20795e6b35dd073af27ba2a738771f4a84e"
    sha256 big_sur:        "90c4a81f113917509a2a321c593836f907dfc5972972f3a82db8e0d04f379c6a"
    sha256 catalina:       "60a3f0a3264e8f1cc42660cb3fe5eb32f03dda311065ea3008f9b15b95ab3905"
    sha256 x86_64_linux:   "ec842b0e266d5c0ab23b5c6a6bba9ede158295f341f5944b0814f3e58149b950"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "jpeg"
  depends_on "libshout"
  depends_on "libvorbis"
  depends_on "pango"
  depends_on "theora"
  depends_on "x264"

  def install
    # Plugins with GPL-licensed dependencies: x264
    args = std_meson_args + %w[
      -Dgpl=enabled
      -Damrnb=disabled
      -Damrwbdec=disabled
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin dvdsub")
    assert_match version.to_s, output
    output = shell_output("#{gst} --plugin x264")
    assert_match version.to_s, output
  end
end
