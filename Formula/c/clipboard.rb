class Clipboard < Formula
  desc "Cut, copy, and paste anything, anywhere, all from the terminal"
  homepage "https://getclipboard.app"
  url "https://github.com/Slackadays/Clipboard/archive/refs/tags/0.10.0.tar.gz"
  sha256 "741717ee505a7852fab5c69740b019e2b33f81d948232894ce294ed0a55e70fb"
  license "GPL-3.0-or-later"
  head "https://github.com/Slackadays/Clipboard.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6747d2a87bd1aa59e30171c55e8c07dcd9d6a153c90c51e33e325a7e5361b5bd"
    sha256 cellar: :any,                 arm64_sequoia: "21b61029176463f416d7d0c4e181c87c7ec0e6d52d1f1f6f3c7eeba61ce26d1b"
    sha256 cellar: :any,                 arm64_sonoma:  "fad69c52a99d680964ba009eacf120896c87b262e708e30ded132894e33a6900"
    sha256 cellar: :any,                 sonoma:        "197516a0ca09d8f459caf3d4ec519d26553a57525a49ae769fe0c56102c08c6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afd9f3678d529ba857fa5be81cc6e6b19949325f6e0c680417a57dcd4d9fe498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbafe6e2061bd73bb093e73edb1b5c1527fffc75c59b8384e14874d82ae109ee"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1300
  end

  on_linux do
    depends_on "wayland-protocols" => :build
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "wayland"
  end

  fails_with :clang do
    build 1300
    cause "Requires C++20 support"
  end

  def install
    # `-Os` is slow and buggy.
    #   https://github.com/Homebrew/homebrew-core/issues/136551
    #   https://github.com/Slackadays/Clipboard/issues/147
    ENV.O3

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["CLIPBOARD_FORCETTY"] = "1"
    ENV["CLIPBOARD_NOGUI"] = "1"
    system bin/"cb", "copy", test_fixtures("test.png")
    system bin/"cb", "paste"
    assert_path_exists testpath/"test.png"
  end
end
