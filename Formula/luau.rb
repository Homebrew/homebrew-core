class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.579.tar.gz"
  sha256 "a44c96766270a4e662f19a6eb8d67e3d71b4e20017dcc0134a1466690520254e"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cc8d9341e6d4bd4fc419b4e2328a19a62f02ec2786bbd50a5ac76666e918cb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb6ddafe8255ed1a570fdf38f6231776a9225e648de29bbcbf399b2298c65795"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cd9b17d97ee085568c8c1e1c166638e625255f7535d427b49320f8cc885be19"
    sha256 cellar: :any_skip_relocation, ventura:        "10a4738bbab01a9dcefd78ad5eddf1db0d2dd26adf57f814745f465ea249820e"
    sha256 cellar: :any_skip_relocation, monterey:       "32893faba189aa664bc6b4769454b8fad2335c1e30a0f023507e1bfdfdaae356"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae8002227d5e4fc729629410bbcf4e7d2cfbe38728bf53a9fd7be3dcb8ee8d95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f36c38c1f0dae2f76b3c12129ae7564187c88dfa38618dda6101384d9ba17ed"
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
