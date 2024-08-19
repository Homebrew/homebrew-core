class Poac < Formula
  desc "Package manager and build system for C++"
  homepage "https://github.com/poac-dev/poac"
  url "https://github.com/poac-dev/poac/archive/refs/tags/0.10.0.tar.gz"
  sha256 "4bdede67b28f9622c071bef8c7eae76062c9ef2ad122deee49d994668e846288"
  license "Apache-2.0"
  head "https://github.com/poac-dev/poac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0e157738c37c61bf49d7ad58a980ddf34fef0de0b5fc30cdbe43b1c117d7b4dc"
    sha256 cellar: :any,                 arm64_ventura:  "3cd45c8deee55c0914aa6cc1cdde7e6a753f6bc6748473a26e8851b388f07797"
    sha256 cellar: :any,                 arm64_monterey: "972f1271f98cfb32e264e3ef89c23d8bfe64b0b74e2408a1e787ea236280b913"
    sha256 cellar: :any,                 sonoma:         "4039f22630e471893bb3b85b5f8a47ae17eb60cd4f05bd93836cea6751200768"
    sha256 cellar: :any,                 ventura:        "902c4aa612e21118bdffa15312aa7d3f02e1fc0aff7dc044f7753b0e97c86581"
    sha256 cellar: :any,                 monterey:       "013b1fd3ec5ed4967917ebab61f7d1efd6c564b47f20bfe80f7b67b060ea2394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ea2528996b633cce529231f48871af4cad1b4dbb1bf5683701e85c2cb56f110"
  end

  depends_on "curl"
  depends_on "fmt"
  depends_on "gcc" # C++20
  depends_on "libgit2@1.7"
  depends_on "nlohmann-json"
  depends_on "pkg-config"
  depends_on "tbb"

  on_macos do
    depends_on "llvm" => [:build, :test] if DevelopmentTools.clang_build_version <= 1200
  end

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  fails_with gcc: "11" # C++20

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)
    system "make", "RELEASE=1", "PREFIX=#{prefix}", "install"
  end

  test do
    ENV.clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)
    system bin/"poac", "new", "hello_world"
    cd "hello_world" do
      assert_equal "Hello, world!", shell_output("#{bin}/poac run").split("\n").last
    end
  end
end
