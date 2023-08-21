class Clipboard < Formula
  desc "Cut, copy, and paste anything, anywhere, all from the terminal"
  homepage "https://getclipboard.app"
  url "https://github.com/Slackadays/Clipboard/archive/refs/tags/0.8.1.tar.gz"
  sha256 "f7ceb2dbb76bc094ac8afbef97bdef0f1a9451ca7dd1a4a181f3b2a859a2f094"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/Slackadays/Clipboard.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8feed1743d3e55ee1e67c1b8085f3cf3a4412e695147426fd3a6339b12e9d8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "231181f3c2a24bc0dd02798b450dd7833f3615ebcbfdd0c53ebc54465ab297cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f8ca9e02c1d1382b380ed7dc07543a383a4089fa21de7424e56a335af62a4fa"
    sha256 cellar: :any_skip_relocation, ventura:        "db42eb5e14ceb1eec15a4a1d77d4c1f0a94f5ac5c28a125863f0899aabd9c403"
    sha256 cellar: :any_skip_relocation, monterey:       "cd70f44184dea81283be87d4b90a0c7c2631dc6fe214e8bd73ca4258231dc7a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d02ded9cabcd024303d12b648383e15183089e56a2bd22254b1d0f2a693abbb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8341584cc82f252d3c52fa056d33b2219254265e46b81b0e25b41b8f70e94efb"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1300
  end

  on_linux do
    depends_on "pkg-config" => :build
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
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1300

    # `-Os` is slow and buggy.
    #   https://github.com/Homebrew/homebrew-core/issues/136551
    #   https://github.com/Slackadays/Clipboard/issues/147
    ENV.O3

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["CLIPBOARD_FORCETTY"] = "1"
    ENV["CLIPBOARD_NOGUI"] = "1"
    system bin/"cb", "copy", test_fixtures("test.png")
    system bin/"cb", "paste"
    assert_predicate testpath/"test.png", :exist?
  end
end
