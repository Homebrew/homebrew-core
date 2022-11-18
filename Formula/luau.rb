class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.554.tar.gz"
  sha256 "46c2cdf633e21f879f7e8b7b72f84d190170c6e697e3a64cee12e9e9ef3376df"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "085bcd8b3088b4a6c10f90288eaca55a44e7247afdaefdea5d11445b35748b4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3429b79e04a301fe8183f37af1f717c041f450aa875983585e223af4f9432fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71b1b8f105484119dce99d50547afc7aa8c0dd5840460736400363c4e77a8074"
    sha256 cellar: :any_skip_relocation, monterey:       "a303c9545074fc1a6b388b494b1d2017d304e3deb9ecc0904af6a292036d4a25"
    sha256 cellar: :any_skip_relocation, big_sur:        "52b0189f48cd94c466882e6930dfa95370fc8233916bb83a26e7a45707896b2a"
    sha256 cellar: :any_skip_relocation, catalina:       "146edaf36bf09d36b37c10763463432ac996a5ae5f0131f89b0976f89acaa688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "992feb3b99ee3f96ff409ed3579304f7a91c001c5a30b56a225a0cb1a4f6b19b"
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
