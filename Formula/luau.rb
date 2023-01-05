class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.557.tar.gz"
  sha256 "e99d2097f69fa53eabf91e74de9c319d933725ea94d3a148a64431a7c2e6c179"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3856494f542d6abfdd19a976a510a63ea6bbdd8c8203a3ca439f122e998a3857"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bb49f723305b7b082f6753cf7db0961670f846fd18f3f0902ba3c4e03aff01b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d27da2c7d9fa968f16c9fb5aca629c142a576632a53a67d7386df1ebbb3f3b9"
    sha256 cellar: :any_skip_relocation, ventura:        "a6169a5276facf092b1dee330147d518017cfc13ff8c8eef282af27810354e48"
    sha256 cellar: :any_skip_relocation, monterey:       "ac91c60bffa8eef0dd5e441a27111277ef487d2aca69fc554a171bac01de02d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d682c5baddb52c3a97c74410a645e5ef1eae884cb2f5b19d2bd6781264174856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "261f06090c7de6a3a9465798000433c411741f281a5fc42067bba90cc405cdc4"
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
