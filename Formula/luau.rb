class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.525.tar.gz"
  sha256 "a8768a592fc429eb6d003e62461230fd2cccc6902804d2fa1a16671fe57f90e6"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b8642d65ebb96311782bc3fc7b128c9b5b55bd4b94b0f3b16e37d60701b2eb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf4b0e81bae49530dddd701bd0b4ee354fb87993ea0380ebeeb9452df0c5cb8d"
    sha256 cellar: :any_skip_relocation, monterey:       "79bce707fb0a2d0fecfa3774601bdf50ff2aa6ebea9adb41eea8fecfd1ddd07e"
    sha256 cellar: :any_skip_relocation, big_sur:        "42af1b65ad3a9d71bbcddc78c3831844a2003dce46884e2a07353795304f0e93"
    sha256 cellar: :any_skip_relocation, catalina:       "9473543423537fc913c721889293d3c1aa95960748b4b73037116af764040e41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "418ccb260372e6ee8106abe05adfd727ebacfd737e3edb02deea642e14c0e677"
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
