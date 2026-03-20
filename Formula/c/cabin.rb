class Cabin < Formula
  desc "Package manager and build system for C++"
  homepage "https://github.com/cabinpkg/cabin"
  url "https://github.com/cabinpkg/cabin/archive/refs/tags/0.13.0.tar.gz"
  sha256 "f9115bb0566800beedb41106e00f44a7eaf1dea0fa6528281e31de5f80864177"
  license "Apache-2.0"
  revision 3
  head "https://github.com/cabinpkg/cabin.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ceb0df820b6831bad382ee05ec258c8170c9a4f6ed52faac9e42928bc3e99d10"
    sha256 cellar: :any,                 arm64_sequoia: "4141bb5f2b68fe40ac121235ca06f81c0eb0b22bdeb00b9cb9c925eaa98a947f"
    sha256 cellar: :any,                 arm64_sonoma:  "d3dcc5269af91e7a87c11ccb90ba7262e5f4a2d887dc9152ba6422fad66d9977"
    sha256 cellar: :any,                 sonoma:        "20944f5509556bde7cfcbcab5829f30b62ea286b675bf06450e2676751dbbd17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21f009801cb40282ccb9374cffc72a5af2e2b4f7b1d9c204ad952cfffbf5167f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b6308c79867c1290e4929b6e4ebf05b6b8cbd958f37fae619663ad954fb4fd8"
  end

  depends_on "mitama-cpp-result" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "toml11" => :build

  depends_on "fmt"
  depends_on "libgit2"
  depends_on "pkgconf"
  depends_on "spdlog"
  depends_on "tbb"

  uses_from_macos "curl", since: :monterey # >=7.79.1

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
