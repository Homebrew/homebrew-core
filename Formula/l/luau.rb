class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.621.tar.gz"
  sha256 "5ade1aaffc352e15ed1030dc4bf0189a03ca20f37e6b0b8b97b1330246ef8b34"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11b3dd9bb660c18ad63d6c7e60773db28f0bb7c5bc3649f3c5c173b3a004242e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a2f6b518df52590b6ffa915127b89fcf31b3dc606c85541cbdb453f7984856f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b36e5afb584029b3d25692e385a46f12c106a82f184e426bd70f1ea9ff6d7429"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8e0a2d945773d9be0bb0ce11e62556b75acb5bdf269c725b51a503ee26566f0"
    sha256 cellar: :any_skip_relocation, ventura:        "84d4992b7279c9ccda2385aa837f58f8b7ba0dd7e401839057379b1e2fdfcb78"
    sha256 cellar: :any_skip_relocation, monterey:       "4815ab30966fdbc68f2c146f1937b273282ae4030e4f5a9824bbe08117a02b7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "882f4836272136bdbede10f0faa5acc42825779c0f36c14795eeb56c6587da8e"
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
