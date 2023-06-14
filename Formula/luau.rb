class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.580.tar.gz"
  sha256 "52e4e0d396bb118f93a36fb202eecb7dff3cd8044f809a11eda2a59c1634d097"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06c46d4a4ce07fcb2e6c2f79c17b4a1b8c670ffc0b5216f433147e15379221e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f191037a7a9353df29701bc113b1eca779d2bd9cde0338af3ad728c085bf2d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc478d5c6c004854400acde941b5a986988a4d3753df0404189319cfecf67029"
    sha256 cellar: :any_skip_relocation, ventura:        "fab020500b20daf4597ee4ab76d8e85b931a7305b6aea0c70d24b148377720d1"
    sha256 cellar: :any_skip_relocation, monterey:       "e02356f063758b31de38aef88d4f1b61d0f36324343052d34f54b52c530351c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa723988b0605cfe0af1ee4170a6e2442d0f9d7625f53f8fafc37bb103d35f08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cbdda858c1bffb274823406b2bec8f45884cdfa69c4f5455ecdb1a304c97fbb"
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
