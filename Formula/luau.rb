class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.546.tar.gz"
  sha256 "fcc07da039a040187aba54a6a221fd553d261836c47a0845d03f8b7f7da5e58a"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7a2b4ec9f3f31cbe926c0d0b51d12635d933eaab4fea24db915b7b73ea84187"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27be5952de56277eb802872ac90a6e5424a45f77924b9e96506a480a1bfbb1e8"
    sha256 cellar: :any_skip_relocation, monterey:       "8b131794ccd02b1832fbac5b94ecb55444a732fdf83b888f2f80811587a4bf83"
    sha256 cellar: :any_skip_relocation, big_sur:        "661d2cd6606dea17628757591d5a2c0eea58520bc9e3657482af72fe4cbe65ce"
    sha256 cellar: :any_skip_relocation, catalina:       "c450a2ae8ea6a06113a71815f1bdaac041f1f240c3f1fc1b0458cfdb791eb895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d717fb564befb7f7e85679e913082599204f623ae211610509bd23152c5cd941"
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
