class GstPluginsRs < Formula
  desc "GStreamer plugins written in Rust"
  homepage "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs"
  url "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/0.8.2/gst-plugins-rs-0.8.2.tar.bz2"
  sha256 "e4c7f92119be776dbdb76f051db3cb543b7f3f38fc190424f396b793187695aa"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_monterey: "eb935b795b91629fcf762ad9f2a40d4e8754a92d2c3b81cba1c0d267fa7644ba"
    sha256 cellar: :any, arm64_big_sur:  "f213ac86c029dc7d79d3eb58ef564f0f3b643b49f99ccdc77b34012545d38c90"
    sha256 cellar: :any, monterey:       "9010f3c7ecd587c907274cc40e7f0e9ec2831119d2b2849c465b0bab6eac0106"
    sha256 cellar: :any, big_sur:        "dbeac573c81819610b88f58b65c5deb32b2bc7f642a80be4fef71651701f449b"
    sha256 cellar: :any, catalina:       "9a73a5618ef67cf837055d563b73e91c54053d7b148b6b8b685eac91a73c22ea"
    sha256               x86_64_linux:   "213b289bcadf2b4d5106cc0805f3036a3e651d050093d61b29ca4f04848b3b2e"
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
