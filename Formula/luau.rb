class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.564.tar.gz"
  sha256 "5d9e0c8e7772409a451ed3f08f29403c83005fce52174150c779595c466e7d67"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0798bb7da6c787ccde2572596775746feeca121841f8dbac5bcda13e403c6717"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "278cd0a4d33db27bf38adf0cdd9c2d5fe7b0041b3f06c93b600ddfdd19ebd79f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4068e23eb4c0b06585ec93b2987da5f2e40927a1d48c505ff015b8b8b0e74001"
    sha256 cellar: :any_skip_relocation, ventura:        "91170f31de202d1fff94e01a00ac84a61e94241744fba5a78babcb004ccb89d9"
    sha256 cellar: :any_skip_relocation, monterey:       "b6832d61a41a80ac1901444b62811f1f12c08d29f5f4d9b9341c7b9774a316a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a85db8eef35974df9e425328a935d7ca3b64abbb7dfd6f2dbc8721ffeb8a39f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b3275835f42796c2578557d945126245c411739802b221dc277d6f5788f5ae9"
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
