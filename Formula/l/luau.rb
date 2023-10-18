class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/refs/tags/0.599.tar.gz"
  sha256 "d540602a441bc16eed753a8f86d7623b45d693b84a57ce3bd2df990f2e568efa"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18f4894965bd626b2dbfb7c64dfebb2f9b4e352671453e566e5e117cac52a6d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "704d4b4cbc88dda61f3edef845c9a1434373a228ca23f07c78ef26b78bc7abfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae8baa3d42c1ec366ac663619017cf2bb6b568af8c59048c01f7ac24a343aec4"
    sha256 cellar: :any_skip_relocation, sonoma:         "b95647546cdf1c5aedb4a22cccab7344b366c9f111ef470da5b49888a6f8c7a1"
    sha256 cellar: :any_skip_relocation, ventura:        "f9d61567335cb75a6c6ee41659a98519c90e918d6591a74504ed22ffaa3f89ba"
    sha256 cellar: :any_skip_relocation, monterey:       "3acf4adb25be4f25f5c974fb2d58ea6d051837ae84de37be061b98bef209049f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19784be24563a33502269e4be496aa6854e20ac058f288f54fd0252ed360a34a"
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
