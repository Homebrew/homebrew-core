class Cabin < Formula
  desc "Package manager and build system for C++"
  homepage "https://github.com/cabinpkg/cabin"
  url "https://github.com/cabinpkg/cabin/archive/refs/tags/0.13.0.tar.gz"
  sha256 "f9115bb0566800beedb41106e00f44a7eaf1dea0fa6528281e31de5f80864177"
  license "Apache-2.0"
  revision 2
  head "https://github.com/cabinpkg/cabin.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "63997b784c8c2f0debe6e8b2e109ebc069de502f1aca39beaa5e3f235bd6a4dd"
    sha256 cellar: :any,                 arm64_sequoia: "9eb8f6169c50ea40094404df8ae7a6e06b4bed08521ed4670afe88236b10f5b3"
    sha256 cellar: :any,                 arm64_sonoma:  "a4b9eb7c190cba254c3da8a093bfc96c7d104984dbce71a81d6269c7d9efafee"
    sha256 cellar: :any,                 sonoma:        "0e0d7cb664e228d889350901e1b0b6c0e65f2a7b02172bcbc4bc8b74e23f63e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bddf4b75ab7f5806cc37c8c8e57c072aa883ed7cb074c6e84b67273ef2d17e6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe70c20668f91cfb4fa803fa476fb5b77bfbc3c8cec91e7f370410e57735be4e"
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
