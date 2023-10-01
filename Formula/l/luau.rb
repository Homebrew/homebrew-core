class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/refs/tags/0.596.tar.gz"
  sha256 "5cfc4b0c8358276a7334ee99dd7c016064810afcb4b5b7b87dac60bd2925f7f5"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd32ac77c92ad0400cf7518822e63b777e21ea73ecf33f89a8f235235232d31e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "868f491c86059b114fbd774fe2095c97376e133aa5d03909eadec1874b49f313"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "703fad3b1d37f6bf8744f398994c58a389ec2ad920bcf9703e747c2881ec2d35"
    sha256 cellar: :any_skip_relocation, ventura:        "97a56e25fe1241dff9c2523753a4d870dd61f264afa90729567fb7e214f45dc9"
    sha256 cellar: :any_skip_relocation, monterey:       "86a06f2069c46471da68181409f6cd560e53e45cf2453dd466d57af8e232d732"
    sha256 cellar: :any_skip_relocation, big_sur:        "c603d4d84dbb9199208df59516c56613c1f2e2fe3d139dbdcadfc62556d629ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d16a8b42bb287a425594c474f37624b279b951f1d127e84c5554792c6670c0bb"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install %w[
      build/luau
      build/luau-analyze
      build/luau-ast
      build/luau-compile
      build/luau-reduce
    ]
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end
