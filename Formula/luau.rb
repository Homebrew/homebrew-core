class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.551.tar.gz"
  sha256 "1708cb643885c34286ad0fad7bd863f19c43ab64151101e817f59db0e5ee239c"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fbfa4f8c89cf3077c1441d4af76fc2e8bcd1f4b7ca35787878ae563b61e5e6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd847ffe32c3a5e4f351cc8ef8c79f7969b971c1c2e147b00a3b680156fcb373"
    sha256 cellar: :any_skip_relocation, monterey:       "3e4f3c302782860eb7dce31a294e02e1720c78e1dcaa2e40624916572fd49808"
    sha256 cellar: :any_skip_relocation, big_sur:        "58941a24449430ce48937626569c440fb7bc87a3f88e0704c4ca5aad2eba3fc0"
    sha256 cellar: :any_skip_relocation, catalina:       "1b9886dafd1878b88e3f20fc8af283606c9461ace24c7cf732004bd8fd465747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3afcd7d9955857718fcfac4eff4125400580b721d4aad0826a3b7230758ba3be"
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
