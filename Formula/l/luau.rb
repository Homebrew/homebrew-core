class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.739.tar.gz"
  sha256 "7eca9d2e4362588e9ce95f2fa976e46252231564b29a88fe77f0806a4eae9b40"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c8d0368d525040312f6b0eb1ca49d52201f8d0e0313d4c7a99acfccf3f231445"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b71a843a24cb1783c9ee595145f12847f8b67b1fbf51434681e641b16bafecc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bcfbbe8404570dcc633a12f805fc0fd5db23f182301fae490208e09a9102b4a4"
    sha256 cellar: :any,                 arm64_linux:       "bedb6aac99db1894b2b0282177ae8d6df3e75a88e39aba55ba6208c43b6e2ed5"
    sha256 cellar: :any,                 x86_64_linux:      "62f6a8fec4a4509fde4c967b1a85b23f276e9945349158ad11977e2e494c4051"
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
