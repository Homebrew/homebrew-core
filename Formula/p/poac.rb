class Poac < Formula
  desc "Package manager and build system for C++"
  homepage "https://github.com/poac-dev/poac"
  url "https://github.com/poac-dev/poac/archive/refs/tags/0.7.0.tar.gz"
  sha256 "8ed0189e3fbb4b1326cb2678f80db1652a77399f5b944c57895ce2e00f2d031e"
  license "Apache-2.0"
  head "https://github.com/poac-dev/poac.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49ee867cb80509d2c32016ba661b885bdee69d7c82c9c18b048b6f38b5ad1870"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4744423cd3e1f5b5886a021f4d522800be16a1b228618cace3a39118d75e81cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1570bb3585d5992a5b80e7e39729137339a91ca332aa52ddd245d5727e61a9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "11188f417a6298fbeb39599a6d93c670360bd2e87b0a5dea9026e3d49ca5f8e0"
    sha256 cellar: :any_skip_relocation, ventura:        "63e3d0e082baa978f1fdea0b605e168ce57cea1fd1dbc4c46bfa22af7ebad766"
    sha256 cellar: :any_skip_relocation, monterey:       "9ac4f686e4dc3cf92e4c80ad9a52186f57ab03272323b8e78a9b0b433276f95c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "902689bc9c40c5d9ac2c51fa4006f45ad7703a8c3f1cec033d2f0fd4d9c6012b"
  end

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
    system "make", "RELEASE=1"
    bin.install "build-out/poac"
  end

  test do
    ENV.clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)
    system bin/"poac", "new", "hello_world"
    cd "hello_world" do
      assert_match "Hello, world!", shell_output("#{bin}/poac run")
    end
  end
end
