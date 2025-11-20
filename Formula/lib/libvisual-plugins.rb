class LibvisualPlugins < Formula
  desc "Audio Visualization tool and library"
  homepage "https://github.com/Libvisual/libvisual"
  url "https://github.com/Libvisual/libvisual/releases/download/libvisual-plugins-0.4.2/libvisual-plugins-0.4.2.tar.gz"
  sha256 "55988403682b180d0de5e6082f804f3cf066d9a08e887b10eb6a315eb40d9f87"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.1-or-later"]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "a9b39959db7f36a26c8ab16323abf734c9f9778ccc3bfd6e07ebef6c2287f39d"
    sha256 arm64_sequoia:  "0203c2ea44c5978e092b682a966a72ec4099bca267a56814bdcb1d350ffac738"
    sha256 arm64_sonoma:   "2f8be28190eb7037ae6b9d2022e52b97f9fd16f0b7ce663f12725fec703951de"
    sha256 arm64_ventura:  "09cc228afa0d75814145656bd4ccc19417bd91267f76e536a031e1e6774fd09b"
    sha256 arm64_monterey: "1ed5a81fc26770e18092cf6ed205635a0a14986a2a9f8b7d1b066125a31db4bc"
    sha256 arm64_big_sur:  "d52b13029a9a4e0d7343edde6d215c43394a236d7eb47cd91d725f6b0c310909"
    sha256 sonoma:         "6b7d4460b4809101e65b924665b3f864d413fb38d083017108b30a80028b34d6"
    sha256 ventura:        "2ee6827428dd600d21412a543dda3adfd279f80645850904860722bbab683d4f"
    sha256 monterey:       "977213a56b8ee0e6dc046a117ca5578d2c3e03e9d9430f32365a16ef224eddf4"
    sha256 big_sur:        "b2202a454a452bb02d49db40379395481fd4a21888a73a0a462b4675ef703052"
    sha256 arm64_linux:    "1a8aa255c27a5600d66d0eba73ac39aa0708439481d577482008523119914708"
    sha256 x86_64_linux:   "dfb02d238ee8abe6fa95c0a0d1d9f4fdc77e5d1946ef670b4bfdae9f481f95b3"
  end

  depends_on "pkgconf" => :build
  depends_on "xorg-server" => :test

  depends_on "jack"
  depends_on "libvisual"
  depends_on "portaudio"
  depends_on "sdl12-compat"

  uses_from_macos "bison" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "pulseaudio"
  end

  def install
    libvisual = Formula["libvisual"]
    configure_args = [
      "--disable-gdkpixbuf-plugin",
      "--disable-gforce",
      "--disable-gstreamer-plugin",
      # NOTE: This relies on brew's auto-symlinking to
      #       <HOMEBREW_PREFIX>/lib/libvisual-<major>.<minor> .
      "--with-plugins-base-dir=#{lib}/libvisual-#{libvisual.version.major_minor}",
    ]
    system "./configure", *configure_args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    libvisual = Formula["libvisual"]
    lv_tool = libvisual.bin/"lv-tool-#{libvisual.version.major_minor}"

    # Test that locating key plugins works properly
    plugin_help_output = shell_output("#{lv_tool} --plugin-help 2>&1")
    assert_match " (debug)", plugin_help_output
    assert_match " (lv_gltest)", plugin_help_output
    assert_match " (portaudio)", plugin_help_output

    # Tests that lv-tool starts up without crashing
    xvfb_pid = fork do
      exec Formula["xorg-server"].bin/"Xvfb", ":1"
    end
    ENV["DISPLAY"] = ":1"

    lv_tool_pid = fork do
      # NOTE: The two lines "assertion `video != NULL' failed" in the output
      #       are to be expected and can be ignored.
      exec lv_tool, "--input", "debug"
    end

    sleep 5
  ensure
    Process.kill("SIGINT", lv_tool_pid)
    Process.wait(lv_tool_pid)

    Process.kill("SIGINT", xvfb_pid)
    Process.wait(xvfb_pid)
  end
end
