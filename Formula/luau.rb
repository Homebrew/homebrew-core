class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.549.tar.gz"
  sha256 "786581ebe7cbbcb37cb4ed9c8817d6689cd82e910b945f2ce17fe6df2888e2d4"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19569c6e5cab0faebb37c336250f764cec5a08bc5e067eff87eb061dac827bf0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25511f190d86f9a142cf37e059496f479e4a03d6d7ad8feecf8aaff303457303"
    sha256 cellar: :any_skip_relocation, monterey:       "9f10fe347822a088c54b9cebd74b50cdafc32f03846660f49e02f5198f90cdc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "546ed26f8e415922f05860d776ada2e4dbc20fe9e5bef2693db96ffb4f04566e"
    sha256 cellar: :any_skip_relocation, catalina:       "05c85efaa2260c1fbf074badc8b7372a760a1448fb6619b4c9c5946db6167bcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fd6f267540bdcd152c53753f0bfb1dfc27bc2c6ca16cbc3d643513c22309494"
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
