class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/1.0.6/qjackctl-1.0.6.tar.gz"
  sha256 "dfffef1ddc65df666a1f0eba89a1d6d85fab47c765a91de36a5ef6360472899a"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/qjackctl/code.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "0bc5962d3381116c34ed5fb4f146cdd8519b356e40fa926428e789381097dd4c"
    sha256 arm64_sequoia: "c6e987bffe341fefb324da4d6fda2654fdc695d623f99be0009ca2349e7296b5"
    sha256 arm64_sonoma:  "aa91d5f22aa395db21d35bb20c05474d99f7debb96f1ca05995ff48005ec8233"
    sha256 sonoma:        "1955e7be6a6dd90086fda9bdb2dae09291e3e219035a594d4f80734101aa1815"
    sha256 arm64_linux:   "f2bcd15543975f6644660f40bcaae2e4b765ecd36a2f66385856ae50d93bd268"
    sha256 x86_64_linux:  "6e20a93d373988625b7c7f9d855fa697877729409b00ac8610b25797eece5ffe"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "qttools" => :build
  depends_on "jack"
  depends_on "qtbase"
  depends_on "qtsvg"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    args = %w[
      -DCONFIG_DBUS=OFF
      -DCONFIG_PORTAUDIO=OFF
      -DCONFIG_XUNIQUE=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      prefix.install bin/"qjackctl.app"
      bin.install_symlink prefix/"qjackctl.app/Contents/MacOS/qjackctl"
    end
  end

  test do
    # Detected locale "C" with character encoding "US-ASCII", which is not UTF-8.
    ENV["LC_ALL"] = "en_US.UTF-8"

    # Set QT_QPA_PLATFORM to minimal to avoid error "qt.qpa.xcb: could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match version.to_s, shell_output("#{bin}/qjackctl --version 2>&1", 1)
  end
end
