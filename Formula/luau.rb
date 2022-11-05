class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.552.tar.gz"
  sha256 "c638aee88010197d7e6f22e592fa12360e38a69f54ed91980b11ac0f89676db5"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce86c49cbd6ee245cfd288ee7e55719582ceed1b1a40f46699375522ad4e979e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6bd4438ebd266933fbc3128a8ff5ac349ef97f3e8c6948e528cbf770a4bab2d"
    sha256 cellar: :any_skip_relocation, monterey:       "9f36ceb3f69102e09b47c8888e68d1b73784773fea4be9a5938be7e1bd781aa4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e215948b2addc96a1bc4f1917903028fe5fa589f482a4203603099d21141ba9f"
    sha256 cellar: :any_skip_relocation, catalina:       "7a0c7275301bde1e8ece90c3f9e9855a95a73826493546cc2e917ddae99055f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6ca0b22d0774a375a0ecd3d6e458528ebf97b2323b206448f0d00a27aba6ed3"
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
