class Cabin < Formula
  desc "Package manager and build system for C++"
  homepage "https://github.com/cabinpkg/cabin"
  url "https://github.com/cabinpkg/cabin/archive/refs/tags/0.13.0.tar.gz"
  sha256 "f9115bb0566800beedb41106e00f44a7eaf1dea0fa6528281e31de5f80864177"
  license "Apache-2.0"
  revision 3
  head "https://github.com/cabinpkg/cabin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "655d17a5bcc97fbca8a4fd30ecb52f5ab99a7f22f3e1d87f65c48929f3215f55"
    sha256 cellar: :any,                 arm64_sequoia: "e48ec00bf4a0ffa5aff7642fddda47b61a6ad6f5597df832cd168d0688fcfb6a"
    sha256 cellar: :any,                 arm64_sonoma:  "8ea19d1c4a8d22b5a73b3fe8620757f8c9a070b082902e0e432e9898f63d596b"
    sha256 cellar: :any,                 sonoma:        "ab451ce1de7b3d7da238f231739a6cdb67855e178c2d9028142302b91bc47f00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8946c1fce21ed1a77a9ecd9e2346337ca93b43d5f783a27957366dd00411fa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "755f23ddb1016e92e704f38eba9391216375643ee2c0ba3ff9ba034038a73a37"
  end

  depends_on "mitama-cpp-result" => :build
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

  # allow to build with fmt 12.1.0, upstream pr ref, https://github.com/cabinpkg/cabin/pull/1231
  patch do
    url "https://github.com/cabinpkg/cabin/commit/b506326b996cd4d5a6578ceb5bbbb7a903dbdf12.patch?full_index=1"
    sha256 "baf74ab11f7a1f7e2a75916acdc7fed76114e24f02e09d057c261b2e469e5203"
  end

  def install
    # Avoid cloning `toml11` and `mitama-cpp-result` at build-time.
    (buildpath/"build/DEPS/toml11").install_symlink Formula["toml11"].opt_include
    (buildpath/"build/DEPS/mitama-cpp-result").install_symlink Formula["mitama-cpp-result"].opt_include
    system "make", "BUILD=release", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"cabin", "new", "hello_world"
    cd "hello_world" do
      assert_equal "Hello, world!", shell_output("#{bin}/cabin run").split("\n").last
    end
  end
end
