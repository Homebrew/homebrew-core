class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.543.tar.gz"
  sha256 "107d9408e2db71ec19434138b428f673ac1674d021f0ccae98af39b364cc2912"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cea1ef8ce04048d8b92027a96de96a3f2d91e82053c6b5175ef5ed59ef638776"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67273bae5f4ebda75aab7b528d38f3894738d0b3bfc58f0a5bcca94c891ce5ed"
    sha256 cellar: :any_skip_relocation, monterey:       "cd3c221821e9178124931344312e1806eed4e9be794d6ebcdd47836dbed3598a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3028130b67052a53d8c4eb13a78ce0182ec964be7afb114cbf0122f09f897a5"
    sha256 cellar: :any_skip_relocation, catalina:       "7742862aa88690a88466ebe5e589e0a4c0769a125203902ccb4f15f28213b393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4162391de01fa74672d87ddad373dfb0d3172e6c3890b5b3c84d71c870283cc7"
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
