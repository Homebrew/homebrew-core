class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.531.tar.gz"
  sha256 "dad818dd2e0d21842139c2c3379e66a0ee5c21a22a865f028495812708885472"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c26d01a5aba740c5243b047aaa4ad5f8b6d4add149066e4a0a2958f9d77d229"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4679650bc46a70ff4adc599baa619750192793acb0b8581b4666f50f18650666"
    sha256 cellar: :any_skip_relocation, monterey:       "44a92eb249a7441f908c311ccaef01bb5fc2639dda7f3217b6cd2d887931334b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9c6e0ec5025e27c37192548205b683300f148b61d6d8105f000e46b6232e29d"
    sha256 cellar: :any_skip_relocation, catalina:       "5ac25eaf50a22af03a0680af2d8df77a787e7b98704c5d8f084442c7e3d8df98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da345a5c1df86821cb9081531a04aa2e92fc79fc62cfca9d8faa8c28a96e7c67"
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
