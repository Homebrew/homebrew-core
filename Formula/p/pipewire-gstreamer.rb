class PipewireGstreamer < Formula
  desc "GStreamer Plugin for PipeWire"
  homepage "https://pipewire.org"
  url "https://gitlab.freedesktop.org/pipewire/pipewire/-/archive/1.6.11/pipewire-1.6.11.tar.gz"
  sha256 "f3f70c4af173cc93d05070a9d412efe3ef5889bdf4ac32298e2c0d9ae1350559"
  license "MIT"
  head "https://gitlab.freedesktop.org/pipewire/pipewire.git", branch: "master"

  livecheck do
    formula "pipewire"
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "4d0a981f105da882efc4358c6116c8400b0ebf72be179933d19ea003b142ef55"
    sha256 cellar: :any, x86_64_linux: "c628de5721763ffdcf4011b777fbd8e3c6c20944c9b26032ed7d293796c5910c"
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
    assert_match "pipewiresink: PipeWire sink",
      shell_output("#{formula_opt_bin("gstreamer")}/gst-inspect-1.0 pipewire")
  end
end
