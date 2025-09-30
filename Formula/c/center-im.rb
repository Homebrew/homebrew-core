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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "0144e5a04086b115b6c21b4c9dd9448ec8a43f965737aaa7ca21213d5d78a1dd"
    sha256 arm64_sequoia:  "70d910d088f565556129872ef5a54c802a0ff2e938e05d2f9315efcd4794fe4f"
    sha256 arm64_sonoma:   "65761f72dce3b59dfa0b058aa2eff754ffb132b9c61e9cf36d595f9ad12b3054"
    sha256 arm64_ventura:  "aeaea7b73d4df68699def112fc0b0108d22af0680a9f8bc1d323b9c605044091"
    sha256 arm64_monterey: "5234f05e2c0871d7df29fa263734ee54feb09de3ee6fbd327ec0d8e3655530ab"
    sha256 sonoma:         "02f27aa633b15c66529bd3d7c9d11f382b4998816fad2f048b1efd11be44cc2b"
    sha256 ventura:        "c39b856a9f8a148f92c600bafb203b135e95ccb34e6a28fa891602c3b6d81858"
    sha256 monterey:       "a8442a0d0e8ba9888577ddfd2d8c76699cb0eb20a1e96c0b0b143186ad27e63c"
    sha256 arm64_linux:    "2a1f98a1195968b86f0fd44b1c115daeb2a54d38161b85339641223ab121fd37"
    sha256 x86_64_linux:   "7148aa25f016c25825f9ed5fb6526d14737ba38208779727937801f2c7dbc42f"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libsigc++@2"
  depends_on "ncurses"
  depends_on "pidgin" # for libpurple

  on_macos do
    depends_on "gettext"
  end

  def install
    # Work around build error on macOS due to `version` file confusing system header.
    # Also allow CMake to correctly set the version number inside binary.
    # Issue ref: https://github.com/petrpavlu/centerim5/issues/1
    mv "version", ".tarball-version"

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
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
      pid = spawn bin/"centerim5", "--basedir", testpath
      sleep 25
      Process.kill("TERM", pid)
    end
    assert_match "Welcome to CenterIM", (testpath/"output.txt").read
    assert_path_exists testpath/"prefs.xml"
  end
end
