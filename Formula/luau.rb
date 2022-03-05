class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.517.tar.gz"
  sha256 "d367a92fc90a1e9b9c1693110208e3854e73cb88db75161c3bb74db9244430b3"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1de33f9f976dbf694f0587229de1118c00de63075a5a0e38cc84c7075a69e477"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fb209998c8a3ec07b085b26acb299788a04705ed721abb185e63d1da073136a"
    sha256 cellar: :any_skip_relocation, monterey:       "024859e4e8c4c289ded2cd78b4097114d14655105848f4e2577bf3520ab12d25"
    sha256 cellar: :any_skip_relocation, big_sur:        "39b6f04119b31d420d12188502eeacd1be7ec6f5d4f9a37ab431f683886397c7"
    sha256 cellar: :any_skip_relocation, catalina:       "0e70971dcd80761ca706363462f94de45ff5a2ac778270d1c5064132d268c2d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a83ce3c06e2e5be088f765b6a8ef6d23359e0bcbd8d39360aa8a5c343a4b6385"
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
