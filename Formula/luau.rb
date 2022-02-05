class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.513.tar.gz"
  sha256 "c7b44a9ab8bf1477e4537016fceb6888dd3e6452c71f10c48f96e824a1c49b7f"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc3c07cd7f660d22e63a0b7b3e206b5a9ae20ed7f63a365b2a10981d8c2f5e9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfc7cec79a46b727d5c9f54f1f515625ee139efd285f7a972d3ff1c1cc2dea09"
    sha256 cellar: :any_skip_relocation, monterey:       "ae0cd211493854ab9121de32feacaf50adb2e4022dec6cb15c1a4d9e44fb00e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b82ee6a4afb16c9a4998b33b3f0b13aefd3ac6a998a1ed0e8b671afcd0aceb79"
    sha256 cellar: :any_skip_relocation, catalina:       "6dc2f4101c903f6d4e3230d528b37ee07491080f8803c17a5278cb51a2209bb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fb497e44fe6f8939fe33c3b454badf96ad8ef22de7c6d248dd76bfda5922c7e"
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
