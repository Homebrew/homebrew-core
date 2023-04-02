class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.566.tar.gz"
  sha256 "6b6cd9c66ffed2be79dd31504233567bc9b7aac78515bce298bdf66ba152c66e"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1f195b45b90285b892c6b0de663a85f4da095e690573a280678822b30975872"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb8570b29062ef7c05f96570c6c56b3c094d21cb475b2f28d880794492464dfc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68a826589e3c73500279e1f64db3f1ba87311524d6744f42a37229d0e5d47a25"
    sha256 cellar: :any_skip_relocation, ventura:        "00f21118cec48488d345dfe32a96e2c22cb27480d14c5b39fee7f3e3dca1d919"
    sha256 cellar: :any_skip_relocation, monterey:       "668e20d526032ea80b13150088248db7b5418d98efdceef8a1cdcaf22c0099e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebde48087eccdad5139e01c223cc61266af64a9a0559332897012dafc41e243c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8d214cf11dbf129dc750ff61570b2b1ae6434d1e488854a21ec74aef8593bce"
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
