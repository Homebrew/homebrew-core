class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.533.tar.gz"
  sha256 "94ba9e9d89d3ba0edb369a4f0647c45c7f1e589e5f2bf5de60469175236f1d3e"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51fba406bc09809e114aef27d97ba9141b783cd0e329f288d12ea423a0c3ada1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7ec479162bf0a78ea6c972fd394713b9b958ca54814411a232021ba925e5aa8"
    sha256 cellar: :any_skip_relocation, monterey:       "9f066e44bbc30e9e8f7edd89b37c5c4bbb401eeba9645b7b0e890b7105c15c7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "527aa50a8fc4caddf5084ae65d91ebcf32af4da04f5adfa5894f082274058730"
    sha256 cellar: :any_skip_relocation, catalina:       "7e13366f756d7d086ea4838872dd7e756f03c7b9e5ed7b05a6a2abdba5e0ea6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be25fa8814c83ace19e2a655131872ea8e0016009932694cb37f9eff33937622"
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
