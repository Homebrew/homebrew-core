class Cabin < Formula
  desc "Package manager and build system for C++"
  homepage "https://github.com/cabinpkg/cabin"
  url "https://github.com/cabinpkg/cabin/archive/refs/tags/0.13.0.tar.gz"
  sha256 "f9115bb0566800beedb41106e00f44a7eaf1dea0fa6528281e31de5f80864177"
  license "Apache-2.0"
  revision 1
  head "https://github.com/cabinpkg/cabin.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "876eb4668247fbac986c3fd6bfb114684640ddc5be5db17b4f745d082fcf8926"
    sha256 cellar: :any,                 arm64_sequoia: "6ab0d5b4f8f0cfd3d8c0251d9d0b905a3ecd28f92c3dab32fc86cbfcce5eafd6"
    sha256 cellar: :any,                 arm64_sonoma:  "1164395228216093cf43e08f16f1ffdf4c2f7a12fdb24e93924158c73f53d155"
    sha256 cellar: :any,                 sonoma:        "8a2af41347bf41feefc39c6e28d420a9bd6da2550022608605a92cef60eb1557"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78178ba52dd8c248b40dcc9450ad780873b9b3c329d032010233268e9fdd089e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30a8896f233b63196d7dae8a32bc50979851fc57a5c925d18b3206ff835f8fd1"
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

  fails_with :clang do
    build 1499
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++20"
  end

  def install
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
