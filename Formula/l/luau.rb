class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.670.tar.gz"
  sha256 "76cd8ae2a1f5eaea726e76c4d0197d374cd6cb857722e64384378b8f3f06ce3b"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c4281e036a59e29b1b8c351b416d6b4fa7808d6f5294705940af69d53a4f01e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b47c7cba6a05cc8b153eed03ecd2e0f8bf6133d7dc4b96f0805d8df58b326a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8571f2964f53395663a64f34df74b422efa62de334afc262bfe47da09834587c"
    sha256 cellar: :any_skip_relocation, sonoma:        "189e3709f041d58fa5f60817dc4c47840dfbf5835cab93bbb0bca189cb4f2db5"
    sha256 cellar: :any_skip_relocation, ventura:       "cad671e08cf6de13393e4c78c24dd4317bb863b08dfd8dbcb3210f2c6f9080c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a38be7c10cb7c0ce6467f7b917df5d3ddcdcb37fd0d12b60d5f82c5000e145b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc20ec8a6450af68cbcdb4cbab3813470f3e25b2cb9c3fbffb1a53f2f5e23225"
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
