class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.544.tar.gz"
  sha256 "c1e2d4e04fe6f191192d1570bd83f96531804fc484a0bc0e00b53248a01d7dee"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17513f40c0300970a678a83b82a5656638f4f12dc40e56d1cb9a28c53d2987e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fed7be81988e94829f0a06fbe181f7155d79646d1460442415e2bdc25ac8642"
    sha256 cellar: :any_skip_relocation, monterey:       "32d90985fe154fd5583f8125eae08210fe919f1e82a1671f5cbe6453d2c84dcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2ff00a456c1a318994044921bcb78329b7482d39dbcae7378ca3768fbf6d405"
    sha256 cellar: :any_skip_relocation, catalina:       "56b8cbe1ad569d477e99c20c57b8939b0f805e82f4776236c534073f2211120a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6135dbbdd2f8fbee1f3f665c7c747ab559f9fc8a6cf158c139a0d3e42e66c3c9"
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
