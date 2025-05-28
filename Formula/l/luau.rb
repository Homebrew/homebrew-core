class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.675.tar.gz"
  sha256 "1ebd7cf26f55bd69cfb94ec031230a9f4ca4af881a142752c11d70d3a8a49b14"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "827547fc0ed2a85ea435180f500f1c1d6eed4764d9b29f7cb19fc40e85657287"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17766d97807f5596e4bc9beb5bedf31cc59b2f557acbed056384c2f32c310249"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3090ede6e40d3a525d8f067e6f005bda03c5d58ff73665e1ed7344cfc653ca5"
    sha256 cellar: :any_skip_relocation, sonoma:        "21996d3a9e57b078abab4b57ca8cf6c6b15984677e4b5cdc549404d24cdfb13c"
    sha256 cellar: :any_skip_relocation, ventura:       "7851236980f0ca3bcf314a5468576c26c767582a590d0bfeae7f3e088573ac04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f586de74b96171248b80e6b0b0e09c6e57cf715ab01622b2475c3fe5f2c94d9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b0652eee3223e323b9589890f4596baebe923516c61efe17bfec829340c1b4c"
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
