class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.528.tar.gz"
  sha256 "056fca83cf7b5322a31d713e23859346717499f9005bf5f25ed3c6789dddc1d9"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fde118b8c0eb54d3f39701d7b9d9ef68152284e2b520084485c103841d68454"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12a6c7a4818a77dad3b04f52a3abcda6441722bd42ffafb359bc2200758f313d"
    sha256 cellar: :any_skip_relocation, monterey:       "1855819c1461408507ff2ce432ddc382ff25d5c8aa0220a42a3b8d1128da6dea"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c0ce051c735ca2ba4b00395c0e4f274e0b7d94fb730116020baa692530cdd18"
    sha256 cellar: :any_skip_relocation, catalina:       "ae55703f07bbab031372d482cee6cf9209e6a54ca8d964ae5267a04574ba03b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a02b1da0e220e69a26f958af590315d1a29202e671af200937ecaca1812ea41"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DLUAU_BUILD_TESTS=OFF"
    system "cmake", "--build", "build"
    bin.install "build/luau", "build/luau-analyze"
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end
