class Cabin < Formula
  desc "Package manager and build system for C++"
  homepage "https://github.com/cabinpkg/cabin"
  url "https://github.com/cabinpkg/cabin/archive/refs/tags/0.12.1.tar.gz"
  sha256 "a8e038452b28880a464885dcbfe515441e0a066e673d3cce5df46871ad4fa38f"
  license "Apache-2.0"
  head "https://github.com/cabinpkg/cabin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f38e629c4c0d3fd5460f41643ce97d2fdeffe237112eaf72937f9570406fa60f"
    sha256 cellar: :any,                 arm64_sonoma:  "63ed7a7e983261f5db9e8c52e53fc0e1ea6c55cdb4a5b1e78c30e1319682918b"
    sha256 cellar: :any,                 arm64_ventura: "faed095c05cd1332b7cc9457a043349184796a8a2be912f53f645c7756c5106b"
    sha256 cellar: :any,                 sonoma:        "80b6c8f156f7e1e2439a7c67bc645c97e162215a447035244795df6bba5cb43a"
    sha256 cellar: :any,                 ventura:       "b36772a8e55457d84da02116e8cd33afd1a845496784998d9f8a830a2cad9b70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7324557007b8078bd0fe5e0733ece75338ad4e63806c426b3f9d423ac477cdec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d53bf646f306baf6e06a3b84e4f560d1b6e7da5694eb39ad2ebb827a0d79b312"
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
    system "make", "RELEASE=1", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"cabin", "new", "hello_world"
    cd "hello_world" do
      assert_equal "Hello, world!", shell_output("#{bin}/cabin run").split("\n").last
    end
  end
end
