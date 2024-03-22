class Poac < Formula
  desc "Package manager and build system for C++"
  homepage "https://github.com/poac-dev/poac"
  url "https://github.com/poac-dev/poac/archive/refs/tags/0.9.3.tar.gz"
  sha256 "122aa46923e3e93235305b726617df7df747ed7a26072ccd6b87ffaf84a33aed"
  license "Apache-2.0"
  head "https://github.com/poac-dev/poac.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1785225d608e672cb6c2e87c61ed4f279c88ab3df2a3af072c513b924e91208b"
    sha256 cellar: :any,                 arm64_ventura:  "0493ca090b07e2a3c1aab065c1d7bba768876d8eae2245fd8aeb46f46827784e"
    sha256 cellar: :any,                 arm64_monterey: "7d60d81ab7426b5783d90efba9bfdee5edead6b13ac53693e9dd6fef35464231"
    sha256 cellar: :any,                 sonoma:         "c9b3b40dfa40db845a9fe4ad8637d46417f73715379e2657e4b500d3ab44d83b"
    sha256 cellar: :any,                 ventura:        "716d4f1244d5878eadcfe7a7a15cfa26c0463fb55839756cfe4c89cecf0ec964"
    sha256 cellar: :any,                 monterey:       "93e919bed7d7631188508a6f3998351693ad4e8d7d39073ea8a6aa368402584f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f9ea4574bde6aea0779dc880e2b301e809af8ae69746620e97cf7b7a99fa1c6"
  end

  depends_on "curl"
  depends_on "libgit2"
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

  fails_with gcc: "5" # C++20

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
