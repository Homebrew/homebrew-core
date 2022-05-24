class GstPluginsRs < Formula
  desc "GStreamer plugins written in Rust"
  homepage "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs"
  url "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/0.8.4/gst-plugins-rs-0.8.4.tar.bz2"
  sha256 "c3499bb73d44f93f0d5238a09e121bef96750e8869651e09daaee5777c2e215c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "330aa9abc8a345f970940379accfc07ae260327378c050ae99b1e00be29a8ea6"
    sha256 cellar: :any,                 arm64_big_sur:  "83814c0ca2a8eafdcf4125782d8c1aa07f39c9808d9b0b8e25ddc70e56115e3d"
    sha256 cellar: :any,                 monterey:       "32acf2cc9b7384b82c553985bbbd19e44654af8fae9af2e884a943688b51fb3e"
    sha256 cellar: :any,                 big_sur:        "901b5456efaa290cf251f4e144a5d94c944a6a4a01af903016460caa52454947"
    sha256 cellar: :any,                 catalina:       "e772e469c2c1ba2b51db20cc2cb3a2daa16a50ca6b935fc0c745874c39bfc324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18e7a94e96e3294e2b67c2c392d9d2a412c85143e790f8aad386e6a9d0329686"
  end

  depends_on "cargo-c" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "dav1d"
  depends_on "gst-plugins-base"
  depends_on "gstreamer"
  depends_on "gtk4"
  depends_on "pango" # for closedcaption

  def install
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
