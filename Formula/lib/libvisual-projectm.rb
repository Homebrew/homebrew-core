class LibvisualProjectm < Formula
  desc "Visualization plug-in for projectM support from Libvisual"
  homepage "https://github.com/projectM-visualizer/frontend-libvisual-plug-in"
  url "https://github.com/projectM-visualizer/frontend-libvisual-plug-in/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "eb8269c2a923546600d3f40ff90c011f03a215847215ee8bef44bfae305b4dd7"
  license "GPL-3.0-or-later"

  bottle do
    sha256                               arm64_sequoia:  "e1413357ae5900e2662f197184b631759a12af9015317566a99db4d70bdc6ffe"
    sha256                               arm64_sonoma:   "b14e174621f4a80eaab94df8972bc26ec2a834a8d84bf66485deceb4b77e0a85"
    sha256                               arm64_ventura:  "7e9ba6250e71e8005b0e00cc6f50f9991cf5158272a439788c0e4f024d9e8eb5"
    sha256                               arm64_monterey: "2d7f170c6c1b1d8fcb45fe09e6a7e44c3662a6d56f78e48fbfe818e8881a39e9"
    sha256                               arm64_big_sur:  "b9730a62abfc75a28d7794640a4430455764f03632ab68f830123ef493a66bcb"
    sha256                               sonoma:         "b22ec30af45e2a51b4fab90edf68182d74bbd93194fb3b664b088980e7f38809"
    sha256                               ventura:        "d1990c6f162f68c59d59443f0e97de4ca3150bc097d3e964354f74812fb7d76f"
    sha256                               monterey:       "5f4a2bfcb6a2984b30ed79ba3234f11caa02423d0843a748c4b0400daed2dc0e"
    sha256                               big_sur:        "f7a682871eb5ab4e001262bbeda434afe1f8520aa80254146e03963b4ddfd9e8"
    sha256                               arm64_linux:    "5a716abc4e3a5db0cc94acc29e10ca98abdefc878c3ab5f1c27c6869ff5a84ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c3a37a24bcd329cb8da341dab08f396654c1ccf7f8e0c7e63adba1626997458"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libvisual-plugins" => :test
  depends_on "xorg-server" => :test

  depends_on "libvisual"
  depends_on "projectm"

  def install
    # NOTE: We cannot write to libvisual's cellar, so we deflect
    #       installation and leverage brew's auto-symlinking
    #       to <HOMEBREW_PREFIX>/lib/libvisual-<major>.<minor>/actor .
    libvisual = Formula["libvisual"]
    inreplace "CMakeLists.txt",
      "LIBRARY DESTINATION \"${LIBVISUAL_ACTOR_PLUGINS_DIR}\"",
      "LIBRARY DESTINATION \"#{lib}/libvisual-#{libvisual.version.major_minor}/actor\""

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    doc.install "AUTHORS.md" => "AUTHORS"
  end

  test do
    libvisual = Formula["libvisual"]
    lv_tool = libvisual.bin/"lv-tool-#{libvisual.version.major_minor}"

    # Test that locating used plugins works properly
    plugin_help_output = shell_output("#{lv_tool} --plugin-help 2>&1")
    assert_match " (debug)", plugin_help_output
    assert_match " (projectM)", plugin_help_output

    # Tests that lv-tool starts up projectM without crashing
    xvfb_pid = fork do
      exec Formula["xorg-server"].bin/"Xvfb", ":1"
    end
    ENV["DISPLAY"] = ":1"

    lv_tool_pid = fork do
      # NOTE: The two lines "assertion `video != NULL' failed" in the output
      #       are to be expected and can be ignored.
      exec lv_tool, "--input", "debug", "--actor", "projectM"
    end

    sleep 5
  ensure
    Process.kill("SIGINT", lv_tool_pid)
    Process.wait(lv_tool_pid)

    Process.kill("SIGINT", xvfb_pid)
    Process.wait(xvfb_pid)
  end
end
