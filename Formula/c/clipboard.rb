class Clipboard < Formula
  desc "Cut, copy, and paste anything, anywhere, all from the terminal"
  homepage "https://getclipboard.app"
  url "https://github.com/Slackadays/Clipboard/archive/refs/tags/0.8.3.tar.gz"
  sha256 "d2f13e66e4b45d2084e2f88b992b36f07faf649fa1a1c5e0acfca303270a988c"
  license "GPL-3.0-or-later"
  head "https://github.com/Slackadays/Clipboard.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ceb1fd987454a8ca12058e4df6b0b6191857698b684ad035b9157ef49a20224"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11c4d713d7a8c6119bc6af8212fe5309ad4a9001308bf27fd32a03ba2d4a2609"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dd723482463f8f1ec8e1ec50d993f93dbc1d7f8715548259cdefc55c560781b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac19981c43e58d203785145b81c3dcf007be2d86cc4e7db903ea1a8f3dec018e"
    sha256 cellar: :any_skip_relocation, ventura:        "d6920fde5b919fe1e528fc29e522bcd8ec30e7e6c1f2ea80b5c2c0d6ba235743"
    sha256 cellar: :any_skip_relocation, monterey:       "15bd629250c9395796087df7736201b0e1e37e2239efba67dbf16473cd20d24d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20afa6b83e9c37ca88f061787f5d19dbff0ac8362ab0a3a2de60b26192bdc70c"
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
