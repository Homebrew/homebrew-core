class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.532.tar.gz"
  sha256 "158168f3d27d63f4ebdfd04c3c8dfb6f9b65d562ce4cd6b5fc8b42ef5acfaf75"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edc8a358962227fceb1970e5b263b7c97638fc0cccd9060e6d685b06d9440b26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe6bd4a6e7e902370be4fdbdda57bcc99b2bd12d987ce396bc2bfc68e2b31180"
    sha256 cellar: :any_skip_relocation, monterey:       "5e7b94405bd0c6bca0931b8ed6d9123b7cb67d9a5a31e8bc98d08d611fed215c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6beb0bb03d91bce002f1b29663fe1e6c1c669424a2c6f5b99d6aa776cfaf17f3"
    sha256 cellar: :any_skip_relocation, catalina:       "e505d8b0ed7aebd266752d7d8e3ef433e9bc24a9a69df6ceac1cf86641076c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f102e1a13f4e07a8770ab28afb1f85ffec08dc2a7e4e4d76e75a9bdcfc81a025"
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
