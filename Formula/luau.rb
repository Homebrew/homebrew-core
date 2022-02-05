class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.513.tar.gz"
  sha256 "c7b44a9ab8bf1477e4537016fceb6888dd3e6452c71f10c48f96e824a1c49b7f"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5f50bdc80a69121a81b8d95c4845db2d807c3ae1f457b53bb6c98d79cc22c08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "986fc4ada6b41ecfec9ad098eb86f5740f90be0d12ece542d18bfb71b402f60d"
    sha256 cellar: :any_skip_relocation, monterey:       "a3e9002fde7a1ca8349892c8073158dc57481f353860d11265e5a03d91bb21ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f27caf898ba5baab9bdf672f403b5d5024a5e7a9010015952325687950765d5"
    sha256 cellar: :any_skip_relocation, catalina:       "cf49cfcda7ab53558df4f350730217939304c5a1b8a94b06f32a32481c7eee71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c55d3d52e668e57c7cf80478164c2e240be634d2149118ef09122aa4aa5248e"
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
