class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.521.tar.gz"
  sha256 "e1d7e321e35e7c14ce8942ab28ac3172e0794f818299b814c3823254042524fc"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d66fcc6f59e6361f5dd795bbe4e5d72b8ed6227e48cb7bf484b53a40a82346a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7a6e398288b9ec7d0b0e07d50efcb9051147b2e402f69801e417c0ae8da90c3"
    sha256 cellar: :any_skip_relocation, monterey:       "393b99d625c9faa6649eb9434d3a0568ab778f5808a32bd5a4c7e52ee31c51aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "91b9918db03165391207b83146bbe75bce6cef8f3bf2ab7ac5c5556c9bdaeb7b"
    sha256 cellar: :any_skip_relocation, catalina:       "1cca5577cc92d25ee200b75d0992a6fb7465b7ed28a5bada3fabe971de273004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b8bc59f965144cdb77cdeaa0d475ae12b6d23297d2e9b37b344e91cac5383cc"
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
