class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.747.tar.gz"
  sha256 "2c72471f91c42af7f2c07cc4cc602b27c215346d491d7ab3d80da63050ad43f2"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8d230d8600bd37ad072961dadddd794e77e18b46994bff0eb23b8f1bddd13d7f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b3589efdc98f1bcfad35047decdaa095d886978a2d10c14e977f7d2fa69c24b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "95c73de71db2be21fd4cfe531c23e443b74265ff736ae1da23bdbb08ac4ac464"
    sha256 cellar: :any,                 arm64_linux:       "27856c6393e99fc6f8af67534ce9bc6707800027e3a126e7668ddf3c6c8f66cc"
    sha256 cellar: :any,                 x86_64_linux:      "7fc4bbe5241b80ac891c1f97928cf0abd01c7f17afa6f4e6c10f06de7931d33a"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
