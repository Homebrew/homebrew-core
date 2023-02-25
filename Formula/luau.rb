class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.565.tar.gz"
  sha256 "44e1401a145249fef18b511f8fbe32ec5f285cfef1a546045d2bb07c48f5a4f1"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3df9b2ce4cb2f4f1c11275b96c4574fc1317841b08d767a57f913d84499a7aaa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef42c6b692aed20efad4465f3ab84b90871f9ba48a4ec5f6b8995ef310d2fc50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6322edf8d62c1a1a9b1d1fc0af9eb206fa40235398b796a9c0b1348e1b60159a"
    sha256 cellar: :any_skip_relocation, ventura:        "75818f5db9d0aa9b59e3dea69a5f56c09fe2149efe6596d039d203008f7fe99e"
    sha256 cellar: :any_skip_relocation, monterey:       "5676843c949700bfa99b3b7460f284dd9f9f0af7d71e2f3e85d0c7333efa76e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "bff55054fc42d354df937c88cc6a4a8ba342395675b8614d0a83e4fe7d9e4f16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ce15f391e1e9a0e7a194ea81c9a029ba6fe012ba34e8a393619fc4081312e68"
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
