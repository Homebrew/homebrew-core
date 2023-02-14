class GstPluginsRs < Formula
  include Language::Python::Shebang

  desc "GStreamer plugins written in Rust"
  homepage "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs"
  url "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/0.10.1/gst-plugins-rs-0.10.1.tar.bz2"
  sha256 "40c801a15136f338f21eb12ef603e794e5eca2dcf4e0fece81a1ecda668f0257"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "4345aea3e6be46623ab99517b0dccb6b60ca9906234512f670c47d2169f7e58b"
    sha256 cellar: :any, arm64_monterey: "c9d028f52d332863a8a5daba6a2b5c8911f3b21694d7795a2c603b6dcaf66e84"
    sha256 cellar: :any, arm64_big_sur:  "b797ed1b876636a50072cb5be7b4974301c2b56d1ab024fd1fbc90a163f524cf"
    sha256 cellar: :any, ventura:        "ade04d23444c76011d4f0c5941323bac9a5f1d5dd7a3a61e95ef427c163049b8"
    sha256 cellar: :any, monterey:       "5b3ae8d0b38ba078825b66334a43ce1afd26ddf881aa0ed0c8868ca03b0a596d"
    sha256 cellar: :any, big_sur:        "62551bedede466dea6326e3584abf6944128c34ebc7446cb4bf919594f96e491"
    sha256               x86_64_linux:   "2dbbceac1e0e65145df412b9eb6d8a66571426d8479e24d5ed2cad1af0b63a6a"
  end

  depends_on "cargo-c" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => :build # for tomllib
  depends_on "rust" => :build
  depends_on "dav1d"
  depends_on "gst-plugins-bad" # for gst-webrtc
  depends_on "gst-plugins-base"
  depends_on "gstreamer"
  depends_on "gtk4"
  depends_on "libpthread-stubs"
  depends_on "pango" # for closedcaption

  def install
    rewrite_shebang detected_python_shebang, "dependencies.py"

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
