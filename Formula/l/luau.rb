class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.618.tar.gz"
  sha256 "bd30f3f77d0a4732470b20667e811c41304802881588dce65099cb13cdcb450b"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3013a0b4e8441687391c9b2fa29bf6fec27725ab6c450daef8293f467923049e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3526fd7e6134e0d3447fefb479c966e078e1a687eafca8b45cec22a14b13365d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbb806a78379748770d2cf38e58057230ceaaccc2f297e45c28fa97193e01ec7"
    sha256 cellar: :any_skip_relocation, sonoma:         "8bbff845c8c21038eb9cd3fc4a0ef6cba8e7138d60e35238f1a3afe1b667d9e9"
    sha256 cellar: :any_skip_relocation, ventura:        "51f39e8dbf80f42ff4616e6a044a293925a91ee8f44736091d4eddb79318b65d"
    sha256 cellar: :any_skip_relocation, monterey:       "9e02bec7a93a1f896de5b86cf624939a5f73b3f1a2e60eb98d14cd2b74b82fc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49a1e7008cec267804a54765643116068f8923b78b2c3b00ec1aba502db40443"
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
