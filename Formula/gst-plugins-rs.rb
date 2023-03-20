class GstPluginsRs < Formula
  include Language::Python::Shebang

  desc "GStreamer plugins written in Rust"
  homepage "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs"
  url "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/0.10.1/gst-plugins-rs-0.10.1.tar.bz2"
  sha256 "40c801a15136f338f21eb12ef603e794e5eca2dcf4e0fece81a1ecda668f0257"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "d1627bb955f6e798cb89d5443cd89cc5bd1b78cdd881cf27b73f3cd76b3ddb00"
    sha256 cellar: :any, arm64_monterey: "6bc8c89ba844d8983a3cb3660b60ea1cbe4d8f79e1b47b0ab3472ca3a12c692a"
    sha256 cellar: :any, arm64_big_sur:  "22aa654c4adc6f605dae499cb802ae5bb77bab12ab0516091798273de77d26b0"
    sha256 cellar: :any, ventura:        "86c87b489e69a9c01285ac5727e566c636c1ae8310a778bfbea3555b6bdb1809"
    sha256 cellar: :any, monterey:       "cf0d0ac159d068145d040d1a3edb35457e2394d3708fc2c01aeeb3e3be6ab9fd"
    sha256 cellar: :any, big_sur:        "8ee09bbaa9b6ff20874c73b3ecde648e7e91016f61e3d97719eb418c8979d209"
    sha256               x86_64_linux:   "bb8bbf2f3d4f673f7da3209b69fdeced59128e6ba0c091a789da3ac6357b9cdd"
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
