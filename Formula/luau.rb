class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.573.tar.gz"
  sha256 "bf61baaa9996831212789122513f974612801b114eeaa8df46d466a715db2d53"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3d287f44551a071675360ec40c2f9fb9a78c52d08e45b13592b6b0e429611f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "533c3675d9299e05e433e1c011ae2cba97aa9a34dd29130c0a7a1b7b257165a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5aa2f0204425e8413a43387decf09e0b2f078bd1a0185cea436092ed2506498"
    sha256 cellar: :any_skip_relocation, ventura:        "60fc5d4417e09476c9ed2a931aa2d600c2c23b108924b74360fbaa11472c1758"
    sha256 cellar: :any_skip_relocation, monterey:       "371b0d1e3555b0e00e7872ccdfbc1f41389499ffcbdb4e2e367a076ce6cb19bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "4dd2a2d88c2ee65fb5f8b7325cecbe2b449b2fc39d06b94ff617c3bd1242e044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03557b184030604f204e502882f9f03d3660934f24d8eb252efade0fbc228be6"
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
