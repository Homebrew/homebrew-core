class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.521.tar.gz"
  sha256 "e1d7e321e35e7c14ce8942ab28ac3172e0794f818299b814c3823254042524fc"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9ca2b81b0a46bd36ff3c687b3e8335f3d3ef11a4444a314f173447781b6d024"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "539c822654815147c814391fbf92b463057416d77e01dfe5d9d532573e809263"
    sha256 cellar: :any_skip_relocation, monterey:       "4370a37ec7ca16076c4fc6d48db3a071fc260de1dbd463deddef433398f6d451"
    sha256 cellar: :any_skip_relocation, big_sur:        "e152e5960b84980f4846599b22375c28556b7b6cf2ef5908856098e45fb5bcba"
    sha256 cellar: :any_skip_relocation, catalina:       "7d824180ac55380861e0594a240de259441885222df9378f71778bbe5f3dd71b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f99e9ea6e27bed399cf18f8556333eff75f878a128048cf2e499203977bee625"
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
