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
    sha256 cellar: :any,                 arm64_tahoe:   "f5aa10de8e148bedda7f84cab8c848b785ab77c5cd5753cfbce5eb88574499c5"
    sha256 cellar: :any,                 arm64_sequoia: "4133bfd9353d194c8b0597eaab4640752c07d53027c733ed1c1056b84a1f74c3"
    sha256 cellar: :any,                 arm64_sonoma:  "f479da9e04d1fe86620fe54f9149d90b4d15eb6945a44380193bd190333e9497"
    sha256 cellar: :any,                 arm64_ventura: "d0415d6ed62ac9d27c7d360ca0d97ba7114c430c4c54fcca252cb3bbae73e39c"
    sha256 cellar: :any,                 sonoma:        "c551b2ece1d81249476f06ee13336c52a948fdf469b02b02b892a16bab58862d"
    sha256 cellar: :any,                 ventura:       "da3319d484d5bff0daff721c5236718d7dc65dd31e2b4352beee5aa4f70e2c91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "222d40b953ed0218c7d3f4b51708294764afd22cb6f9fbdffa5c6cd9465a6c34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d390684f0efa26d3fe4a5a5b93f98daaf10c678cf1b0a638ae52aeca7ec1ebb"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

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
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1300

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
