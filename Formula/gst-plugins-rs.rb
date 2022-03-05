class GstPluginsRs < Formula
  desc "GStreamer plugins written in Rust"
  homepage "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs"
  url "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/0.8.2/gst-plugins-rs-0.8.2.tar.bz2"
  sha256 "e4c7f92119be776dbdb76f051db3cb543b7f3f38fc190424f396b793187695aa"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_monterey: "a3802fc305bde471df4c11f961ceeb3b4dd3a4af938b995f419292e5c7e259b7"
    sha256 cellar: :any, arm64_big_sur:  "3db03677afa994cd1270cad487c54d0b0ec1f85bea817b689c44ea8bdc939c24"
    sha256 cellar: :any, monterey:       "06f869701fd1e4eba9225b3e9de8896a2f0d87bdefbab115f41b8add04107f3f"
    sha256 cellar: :any, big_sur:        "8732eac4a86d81dc9335906b73a0a8210b52e4587adf137d6340f6218ce6f2cc"
    sha256 cellar: :any, catalina:       "247e255c141aba19c66229e6340daabb4f62b72943320e6767aa4b858c68466b"
    sha256               x86_64_linux:   "4c2ecd83790f0dd065f5be03644caa98148939a621a4746a1cd34fb1dd33ded3"
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
