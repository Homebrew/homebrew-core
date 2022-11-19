class GstPluginsRs < Formula
  desc "GStreamer plugins written in Rust"
  homepage "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs"
  url "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/0.9.1/gst-plugins-rs-0.9.1.tar.bz2"
  sha256 "8d812ecc4124196b77b93f4922cf1e1409a44632dacc69e28b9d189dfaf34874"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "919fe1d643d32b727d5f074f64be8fead7c8938bda439b4195438e442eb56633"
    sha256 cellar: :any,                 arm64_monterey: "63dae8a153e2bdbd5df4aefcd3b9f0284193ff6c445622fa6856e576b81e124b"
    sha256 cellar: :any,                 arm64_big_sur:  "a4c0725297a1aa516636d8dec7c575a88c77845cff2fd79c580675dfe93b1bca"
    sha256 cellar: :any,                 ventura:        "9c5a9261259d62b6038edefd4c3142c81f272ca3d8939dd186dafd470d0a809f"
    sha256 cellar: :any,                 monterey:       "4b5f251c5bf0f1f48eb842560401ba33d0abec017a6011c75457e5a732484204"
    sha256 cellar: :any,                 big_sur:        "15033557efa198a8dcd8fc1e3ececa06be5a39324a6138ff309678df2122bc03"
    sha256 cellar: :any,                 catalina:       "d62686f1996af06e4302a5f9dd7f4d12c5d834aa7724ed1ffddddf357cd1af93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36987244d8cddf346769d29128e7172250d3faf909e75c35add9f09312d1d778"
  end

  depends_on "cargo-c" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => :build # needs python with tomllib
  depends_on "rust" => :build
  depends_on "dav1d"
  depends_on "gst-plugins-bad" # for webrtc
  depends_on "gst-plugins-base"
  depends_on "gstreamer"
  depends_on "gtk4"
  depends_on "pango" # for closedcaption

  def install
    # Fixes an issue where the wrong Python is picked up in the Linux build
    ENV.prepend_path "PATH", Formula["python@3.11"].libexec/"bin"

    mkdir "build" do
      # csound is disabled as the dependency detection seems to fail
      # the sodium crate fails while building native code as well
      args = std_meson_args + %w[
        -Dclosedcaption=enabled
        -Ddav1d=enabled
        -Dsodium=disabled
        -Dcsound=disabled
        -Dgtk4=enabled
      ]
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin rsfile")
    assert_match version.to_s, output
  end
end
