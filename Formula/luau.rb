class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.568.tar.gz"
  sha256 "8218f1943b53439b9cc076bcb6d6223c089093659cc75dda6e2695ee9b370a8c"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5645fea2190bf2975530ab7b5e51c4fd50445463571a5f51018b8be8955320db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa53cbb2ec5c5f67fcbda3e62907314034bfd2b2f88c5df8b0c13d9d4d541138"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "caa4fbe983bb577442d65eb5ab27001f4eb13250608cd29e3d33ee5265339e31"
    sha256 cellar: :any_skip_relocation, ventura:        "77a1c53564606ef20b7d9c251e2ff1ecfe2eab71a2b8f692ec36e530df7d425c"
    sha256 cellar: :any_skip_relocation, monterey:       "b425808438da685347e73f31ea0c81a88d64bb5eba06b2438f1601827312314f"
    sha256 cellar: :any_skip_relocation, big_sur:        "13cae5cfd9fcc04118468cac27b6cfa9c5af6053ba84e11350c6bdab71e1a01c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "656b646f109a77e9687d009a39e5bd100752f81a0197c77632a332990d966387"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/luau", "build/luau-analyze"
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end
