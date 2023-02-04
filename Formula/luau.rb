class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.562.tar.gz"
  sha256 "fa5d10356b287a8290ecdc066874870aa07bb1e5039e09bf1cddba0f8ff4d743"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6337f9ceea1fbf64e74d56016c9e786adb343f2e2f536e0e7b86b6b8bcc28926"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff49e2b2ff51de9aefd61df27ac57567cd659bfaa4fe5aa8c8ffac36fd1fb9ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92f607de4d45fe86456c725751a559a07286620b3052ca650b094e82c0cf06e0"
    sha256 cellar: :any_skip_relocation, ventura:        "5047e815ec5b3b6fb68cbcc18f81b99acaaa0434b2a49712120493245710ddf4"
    sha256 cellar: :any_skip_relocation, monterey:       "5579596a23569ac5821c742502b4ec097f3c4e8cb39ab415718524223f156bd7"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf0bd243f47647e55fe27790a6fcb9dcd410255c4e03a41980e0bcf13c1bb44c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1173e2537e7a7670da868303cad0dcf89bf86307a86d391a6e9c28435ae72113"
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
