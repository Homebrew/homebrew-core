class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.671.tar.gz"
  sha256 "c517da25dc4cdfed9587aeec8e38acc841c4b3bb2d4959869560222005e2ce69"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb46eb8609d9548b7b3c2c14834f7276b4f29593b6b63e73fa6bcf5a33a2bd2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10ad0ef46c98de63bd3f02c0fe92e4d7198640548873c179baf1305949d3242d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "022c2e4ed0d2cf799bbec50b7efa45e82004b564f280886d25fa50e711e9b5b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d094ed54e84bcbe9b1f7d1a365ff21d9cb0a3e51e6885c688f7d0553152149f2"
    sha256 cellar: :any_skip_relocation, ventura:       "5a12545b7fd5201ee9e92a2ea84f36118017b30d89a1d715a4117ad97149c1d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d91076463bd995a974c1419959bbad06e0ce3065ee4b7108e3a6dd689d7bbe55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60d6eaa86ea8697ed5e401b26ac915411778bb8cff6a01191b62334cc0d8da1a"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install %w[
      build/luau
      build/luau-analyze
      build/luau-ast
      build/luau-compile
      build/luau-reduce
    ]
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end
