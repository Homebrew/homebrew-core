class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.672.tar.gz"
  sha256 "06dfc1485b6cda2ff6a78d6960ed750e37e93538ea645a510bca77e0b89d9fcc"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70621e8c15537003b9cb3e3a8f03e1686eff56f561553002b9f53915c6bb812c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c17d4f0b9b71cf22efc29175d5a747d3463e3ea60c8f4923d872a41d820d9dfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ec5cd35d5f5735f4b367fb1b3482e700ca68299b84fc9e409baa3f84b623b90"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c11923598f257557997aff8eb7bfdfb3bf1d40565e068f2c520c82afdb58f47"
    sha256 cellar: :any_skip_relocation, ventura:       "ad8630447184d6df173be27cc349d945be032c35f4a579d8709b451ead0f247f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "513b731d7b905f4f79bad6e356f92013729e068acdccaaa6947cddb6e912a7e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "417bac8eaebb7dcaa72df7e239fe1b38f685d7df974e3b0d7e36c57b134a290e"
  end

  depends_on "cmake" => :build

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
