class Cabin < Formula
  desc "Package manager and build system for C++"
  homepage "https://github.com/cabinpkg/cabin"
  url "https://github.com/cabinpkg/cabin/archive/refs/tags/0.13.0.tar.gz"
  sha256 "f9115bb0566800beedb41106e00f44a7eaf1dea0fa6528281e31de5f80864177"
  license "Apache-2.0"
  head "https://github.com/cabinpkg/cabin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "beb71dbc4d107c7296107d2781dfab1405dc184d5b9ad90ac875c51699378618"
    sha256 cellar: :any,                 arm64_sequoia: "5685234dede00370f7c46d3b6c0733d3291ab36c84b3ec865a7854e125fec004"
    sha256 cellar: :any,                 arm64_sonoma:  "53fbec25916411c2273c8b33724a2a14ad75205671539e4ca6d08f21167ecab7"
    sha256 cellar: :any,                 arm64_ventura: "eb9d82658aa6ea34f500dc9ce4630957c4f4d1b2b35136f974d91e348ffa5ee7"
    sha256 cellar: :any,                 sonoma:        "e11bdfff7ca8f2ac4edcee6dd6dea5580bf1aaaef3876593039cf599e91085f5"
    sha256 cellar: :any,                 ventura:       "77176f2a7288d3b6e0a824ecb3bd1092275a24189d0a0b0b16f31de8c8a86e4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f1177ed3a2f0fff39c50c9061cca22e1c9d166a4ffa14474e458c2acd848716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a7d46c04cd3b626a16046a0940cf17d715fddfae02435a2b0e859e5bcc36250"
  end

  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "toml11" => :build

  depends_on "curl"
  depends_on "fmt"
  depends_on "libgit2"
  depends_on "pkgconf"
  depends_on "spdlog"
  depends_on "tbb"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1499
  end

  on_ventura do
    # Ventura seems to be missing the `source_location` header.
    depends_on "llvm" => :build
  end

  on_linux do
    depends_on "gcc" # C++20
  end

  fails_with :clang do
    build 1499
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1499 || MacOS.version == :ventura)
    # Avoid cloning `toml11` at build-time.
    (buildpath/"build/DEPS/toml11").install_symlink Formula["toml11"].opt_include
    system "make", "BUILD=release", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"cabin", "new", "hello_world"
    cd "hello_world" do
      assert_equal "Hello, world!", shell_output("#{bin}/cabin run").split("\n").last
    end
  end
end
