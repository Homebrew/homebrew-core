class PipewireGstreamer < Formula
  desc "GStreamer Plugin for PipeWire"
  homepage "https://pipewire.org"
  url "https://gitlab.freedesktop.org/pipewire/pipewire/-/archive/1.6.12/pipewire-1.6.12.tar.gz"
  sha256 "73dd5d5c7e67993d33de0930df5189bd5cb8883d8e3c81ab7866b1370f029eb3"
  license "MIT"
  head "https://gitlab.freedesktop.org/pipewire/pipewire.git", branch: "master"

  livecheck do
    formula "pipewire"
  end

  bottle do
    manifest_sha256 "1d15e6ff2b22e5e54cf903644412aa9d29835244b017b9fed39f8df9a1c8a3d0"
    sha256 cellar: :any, arm64_linux:  "4c9a49a1a9aab8a8df0091237ee57af8f60dc04c2fd450ae0c2ba07f5588cfc5"
    sha256 cellar: :any, x86_64_linux: "70000b6fd0b74b0496189ec41f6224472a59bc1ad452fded686e408b0062af63"
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
