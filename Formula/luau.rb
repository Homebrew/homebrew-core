class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.575.tar.gz"
  sha256 "a48908ac8e0b213da6a1066c46687df25c402fc8205e5f72c44541eb1a857bb8"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c79a2489591a6d41fce9e46410311fbd779b2825c75f95316b7ba3f50242ba0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b86bb160058e80524381dc137b694657bcba0a3207927bcacf7e7594a8f9d5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d33d2649b6de6d5473d6a219dbe51a839b9baf17b96646934d0b97d3daba01bc"
    sha256 cellar: :any_skip_relocation, ventura:        "d04ec733123fb459691319bfe783c5fd768fbfc75b44d6027c2f36ae5c01c86e"
    sha256 cellar: :any_skip_relocation, monterey:       "9a8fab621eb50ec372c246e0071f370007d8e8e72f8aa7cadfccf3da11f31563"
    sha256 cellar: :any_skip_relocation, big_sur:        "262c72527bf43ad906b913e57117b95a1178e7b3a70dbfdaed7afbc91ad6aac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b573543f1d2e5b678ddb070c349a3ef938e7951dc6dffb7d66427f1c1ca27b5"
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
