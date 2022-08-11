class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.540.tar.gz"
  sha256 "84b3e52b3b0ccf4d5bc0e0c04055f3a9b2f045c1281e203a858335a6fe76b0ff"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "522e7a95a18ac09caaa47a42db6b70835067963da061230d99714b2efc7bc42f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ac7fb5b4d0b5911aaa6ba003b01c53c11543b266b2a4dea898a82e9eadfb19f"
    sha256 cellar: :any_skip_relocation, monterey:       "1621dfc50a7cffdc4fc6110c8c3ff83c61ab6b902b70891d549d7ac7a111e9ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc225b442cbb8471ed1f4309346be1083af1d803ed69fdd57cd49e3ca5b3848e"
    sha256 cellar: :any_skip_relocation, catalina:       "be9ead7af35f754962728648054def38613c744f8e20724213da62cd27cb148f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ce87a59139e37847a0db2bc64400bff956a3fef2c9aa76fb7df15ff8b9e8c97"
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
