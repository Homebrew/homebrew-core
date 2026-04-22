class PipewireGstreamer < Formula
  desc "GStreamer Plugin for PipeWire"
  homepage "https://pipewire.org"
  url "https://gitlab.freedesktop.org/pipewire/pipewire/-/archive/1.6.4/pipewire-1.6.4.tar.gz"
  sha256 "e31ae906dc7fee1c56ccc4279247b385685b926b3f900cebd910d4bd4403d86b"
  license "MIT"
  head "https://gitlab.freedesktop.org/pipewire/pipewire.git", branch: "master"

  livecheck do
    formula "pipewire"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "d294e3544b75bf34db5a55bf16957f8f5a2974064709679a9c225fc56b6b2137"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1868acbab424c7cf16fbdfa4b291aaea5d69edc90dc965e8bad19a185596059d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "glib"
  depends_on "gstreamer"
  depends_on :linux
  depends_on "pipewire"

  def install
    args = %W[
      -Dexamples=disabled
      -Dgstreamer=enabled
      -Dgstreamer-device-provider=enabled
      -Dsession-managers=[]
      -Dsysconfdir=#{etc}
      -Dtests=disabled
      -Dudevrulesdir=#{lib}/udev/rules.d
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose", "gstpipewire"
    (lib/"gstreamer-1.0").install "build/src/gst/libgstpipewire.so"
  end

  def caveats
    <<~EOS
      For GStreamer to find the bundled plugin:
        export GST_PLUGIN_PATH=#{opt_lib}/gstreamer-1.0
    EOS
  end

  test do
    ENV["GST_PLUGIN_PATH"] = opt_lib/"gstreamer-1.0"
    assert_match "pipewiresink: PipeWire sink", shell_output("#{Formula["gstreamer"].bin}/gst-inspect-1.0 pipewire")
  end
end
