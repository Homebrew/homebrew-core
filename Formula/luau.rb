class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.569.tar.gz"
  sha256 "53f6fd5aac5f8029b32938fa96a265df694421945b46e4d5634767176b7e492c"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aed822205b02bb07b8a97e8b2908a9c61b0346c6ebe66a4f9eb4ec47927532c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b09f13de4fb28d3856586cfd3b2f9b57528efcc0afbc3f5d14fe8b4800aa4640"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05d6cdb8664a5f5aa1e41588149fd3ee0c85a75ad57348f1985e1cd5aa8530f8"
    sha256 cellar: :any_skip_relocation, ventura:        "116939d0e2724ebcf88bab07e4ab948cca8586590c1b88495ddefa8c32fd0444"
    sha256 cellar: :any_skip_relocation, monterey:       "8bb99b43e90659835eebbfb7748035bc10ab3ad5da86ab437df30048f9c9b538"
    sha256 cellar: :any_skip_relocation, big_sur:        "35d5b80b09e69ecc41994e3c155406d1b23995221d1dc39647ee8b7c8042361c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b1a28230e5ccbd2f3ca33a1ab63015f7684b9bd31412dcba0f5f051722cf74e"
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
