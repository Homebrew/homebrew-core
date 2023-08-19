class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.591.tar.gz"
  sha256 "5943d66439a1902e555fc5595e28d96b8722eda4ac81c385a69b5b9d0ed60cff"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b415a1854d8967a780ffc7144a450a17c2da37b75a586dd2223c21349e6b5df2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdda9822b1cb8cec05da55b923e849e97c8cbbb46933547c0492b0ae1df5365d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "649ba0bf0e6674597ed13a27c509211188e6a34bdcf3e66fbbeb98f133e4c0ed"
    sha256 cellar: :any_skip_relocation, ventura:        "9aec72f12417cc456147ccc87a5c1e4b591ad996dec274fef62935559f7ef4b0"
    sha256 cellar: :any_skip_relocation, monterey:       "a5d830d6a59f11b371e6c503af846f23ef650af45e442991c2308628faca7eae"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f6affb95a8ad5f53a494fa441dc6296485e396836094dbb368dea5f13698579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f4b9e0b45ddb2fe52f2cc542e1dc0a95532deaaf05eb58edee4c90bad638097"
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
