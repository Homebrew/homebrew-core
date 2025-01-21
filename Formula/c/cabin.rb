class Cabin < Formula
  desc "Package manager and build system for C++"
  homepage "https://github.com/cabinpkg/cabin"
  url "https://github.com/cabinpkg/cabin/archive/refs/tags/0.11.1.tar.gz"
  sha256 "3c9bd2898e6fe692eb988dc71f22214ff938255ef2282d5d7d9c6bdf149d173f"
  license "Apache-2.0"
  revision 1
  head "https://github.com/cabinpkg/cabin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7327067ecb4450c4fbc39652c1d1244d95140de92191c4ac82e6043f23e542e3"
    sha256 cellar: :any,                 arm64_sonoma:  "b4a7af27d3b278dec5584f8d1e71162281bed77c2d661e731a8f0e8280e87144"
    sha256 cellar: :any,                 arm64_ventura: "90ca58fc4591819dd7bdb0a62d766d219de1bba32007fda30c85290e595c935c"
    sha256 cellar: :any,                 sonoma:        "edcff193af9aa1f0eeea737a3b8ca9369c1c8801ccfbbba7ef564911cea2bcaf"
    sha256 cellar: :any,                 ventura:       "b1605b98b0f7351d70be33d99a7d6d96061519723dbe17d96601bcb3711bfa9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95337e4be084788162d2ed9c63fbfa120e7e4a91213a0b24638460f3711bd784"
  end

  depends_on "nlohmann-json" => :build
  depends_on "toml11" => :build
  depends_on "curl"
  depends_on "fmt"
  depends_on "libgit2"
  depends_on "pkgconf"
  depends_on "tbb"

  on_macos do
    depends_on "llvm" => [:build, :test] if DevelopmentTools.clang_build_version <= 1200
  end

  on_ventura do
    # Ventura seems to be missing the `source_location` header.
    depends_on "llvm" => [:build, :test]
  end

  on_linux do
    depends_on "gcc" # C++20
  end

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200 || MacOS.version == :ventura)
    # Avoid cloning `toml11` at build-time.
    (buildpath/"build/DEPS/toml11").install_symlink Formula["toml11"].opt_include
    system "make", "RELEASE=1", "PREFIX=#{prefix}", "install"
  end

  test do
    ENV.clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200 || MacOS.version == :ventura)
    system bin/"cabin", "new", "hello_world"
    cd "hello_world" do
      assert_equal "Hello, world!", shell_output("#{bin}/cabin run").split("\n").last
    end
  end
end
