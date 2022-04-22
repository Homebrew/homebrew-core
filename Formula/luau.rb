class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.524.tar.gz"
  sha256 "dfb29e87b86e3fabc484b606ee0af416d0a5b297eab9f416fc815afb5f0ff5d0"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b715ab05408a3a0b86ab64819f76aea7ce77d3f4b386a737db2a3870be8fc6da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ef8ee86d569a5141a437f9d2283614f33b794373a128b4a9bc47383dd1acf4f"
    sha256 cellar: :any_skip_relocation, monterey:       "5656ad32b412e6a1dd2245cbe15c24c7edfc81839eb89bb887278cf12008e302"
    sha256 cellar: :any_skip_relocation, big_sur:        "004add84493ff5265d7c1bfc8dbc88e0c4adca9dee5d88cf55ed01f9f60c0a6a"
    sha256 cellar: :any_skip_relocation, catalina:       "0b1c0a9f50a2d44294dc5a71c0b3448e9a0fdc44e75afb03a30764650d82a0be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00bb9805e2de5ecd173cfd2f16b3c75fb106eb6e518051568442a5c243939328"
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
