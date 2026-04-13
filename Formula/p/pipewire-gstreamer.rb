class PipewireGstreamer < Formula
  desc "GStreamer Plugin for PipeWire"
  homepage "https://pipewire.org"
  url "https://gitlab.freedesktop.org/pipewire/pipewire/-/archive/1.6.3/pipewire-1.6.3.tar.gz"
  sha256 "93db72dc06768db548d48ae2b8e96e7c299c89a47f5c4426f152221aa90b0f2d"
  license "MIT"
  head "https://gitlab.freedesktop.org/pipewire/pipewire.git", branch: "master"

  livecheck do
    formula "pipewire"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "74f11344c9e980abe841cb5cd5aa21bb7e28dab15abe3905a84ef59f22667310"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b647033f79e6cabc497e8af0075579aca588bc96362af8995e5f4f54c66d1c77"
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
