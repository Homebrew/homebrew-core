class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.531.tar.gz"
  sha256 "dad818dd2e0d21842139c2c3379e66a0ee5c21a22a865f028495812708885472"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b290403dbda58e4cd5a9b598f759769e701dadffc9186619ca4a071ca1366bd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0feb6df22ebc6f59cec0cf7b454ab3f2a19e51678f5feaeb5ead8abad6b0a05e"
    sha256 cellar: :any_skip_relocation, monterey:       "e5af5b40a4ef0f8c8be8d7480f1a3d16b37bb5c79f296a7c04f8fd5783f805a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f7b11b2004e2a1bfd5f90dadacf73f1a1e87bfc6faff06e06409e6155cb187c"
    sha256 cellar: :any_skip_relocation, catalina:       "811d33a9337a602af4318869f33471825f1792ea6162b41c4c714c3cfd836924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bf8a5994c053f4006db3ec6530c9e89b6d9a401d4d21c60eb287d879e86dd14"
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
