class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.569.tar.gz"
  sha256 "53f6fd5aac5f8029b32938fa96a265df694421945b46e4d5634767176b7e492c"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3bdb979b0a5a72ff49fb321c4b7e81dc93e95b2cb5cce63adf57ecb82894c19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3696a7c6b5fd72c7aecd98ead0e9a49b1a7b98d73d7d7817e51aa641880531c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00ea057df6a1fb98b90006180e3f02e37daa560af2f317232552b45874db7243"
    sha256 cellar: :any_skip_relocation, ventura:        "44eaec702e8dd5f6048c668438a70d7391d76885fc547a8cca5725d4926ac46e"
    sha256 cellar: :any_skip_relocation, monterey:       "0eed6f0cefd6d2dc2181cbd28031b86471538c9832568a34e6b0eadda029f228"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff48acbfe73d589fc0e21a7aa2c27348f38e8ff9274ac828e794c82e8544e53c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ba0f7e7247691b4b038d6f782ade0ca87f15bd88e1cab53a9286fae440c1849"
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
