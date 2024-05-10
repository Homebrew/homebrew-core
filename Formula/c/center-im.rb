class CenterIm < Formula
  desc "Text-mode multi-protocol instant messaging client"
  homepage "https://github.com/petrpavlu/centerim5"
  url "https://github.com/petrpavlu/centerim5/releases/download/v5.0.1/centerim5-5.0.1.tar.gz"
  sha256 "b80b999e0174b81206255556cf00de6548ea29fa6f3ea9deb1f9ab59d8318313"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "65761f72dce3b59dfa0b058aa2eff754ffb132b9c61e9cf36d595f9ad12b3054"
    sha256 arm64_ventura:  "aeaea7b73d4df68699def112fc0b0108d22af0680a9f8bc1d323b9c605044091"
    sha256 arm64_monterey: "5234f05e2c0871d7df29fa263734ee54feb09de3ee6fbd327ec0d8e3655530ab"
    sha256 sonoma:         "02f27aa633b15c66529bd3d7c9d11f382b4998816fad2f048b1efd11be44cc2b"
    sha256 ventura:        "c39b856a9f8a148f92c600bafb203b135e95ccb34e6a28fa891602c3b6d81858"
    sha256 monterey:       "a8442a0d0e8ba9888577ddfd2d8c76699cb0eb20a1e96c0b0b143186ad27e63c"
    sha256 x86_64_linux:   "7148aa25f016c25825f9ed5fb6526d14737ba38208779727937801f2c7dbc42f"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsigc++@2"
  depends_on "pidgin" # for libpurple

  uses_from_macos "ncurses", since: :sonoma

  on_macos do
    depends_on "gettext"
  end

  def install
    # Work around build error on macOS due to `version` file confusing system header.
    # Also allow CMake to correctly set the version number inside binary.
    # Issue ref: https://github.com/petrpavlu/centerim5/issues/1
    mv "version", ".tarball-version"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/centerim5 --version")

    # FIXME: Unable to run TUI test in Linux CI.
    # Error is "Placing the terminal into raw mode failed."
    return if ENV["HOMEBREW_GITHUB_ACTIONS"] && OS.linux?

    ENV["TERM"] = "xterm"
    File.open("output.txt", "w") do |file|
      $stdout.reopen(file)
      pid = fork { exec bin/"centerim5", "--basedir", testpath }
      sleep 10
      Process.kill("TERM", pid)
    end
    assert_match "Welcome to CenterIM", (testpath/"output.txt").read
    assert_predicate testpath/"prefs.xml", :exist?
  end
end
