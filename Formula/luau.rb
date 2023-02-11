class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.563.tar.gz"
  sha256 "717c1b3e03d20829d75eb484e0699fc824b651b8f394164bc4ab8194482890b2"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fa52e2ccb86370c43e3dc5e1a5345f645b497a95caf4b5f33b27f023ba0af74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "014e657ea13fa788baff96387f75864fa0d0fd4a2f8316805f9dd77d3537ad94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d5536e3125689c553e3740ae6510d775cb3efb83e60026ffe16cfdbe61925af"
    sha256 cellar: :any_skip_relocation, ventura:        "7fff4426b82fb0939f8fc0914d5edaca98466b5098e0e42de3223b37719d0799"
    sha256 cellar: :any_skip_relocation, monterey:       "d1c468ea097176b00d37d6adec50ebb8972880409bdf4dfdc488a003211e71de"
    sha256 cellar: :any_skip_relocation, big_sur:        "06b48944323a27269a8328c29dff5d4ef50afc3539de0029a37d07bba97681d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9168ebeb8cbab9aa2404d7299243930b716c6c10726483630603a23ba744f8f4"
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
