class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.746.tar.gz"
  sha256 "5bdfb1fb6f5bbd0af7056ba07f4e91043dd5615a7a9a61ed1498f8f67b991ac1"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a8c08e27e085cae26e01a471acc144cc16ddc939b60299b9a296d44b3703094a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1f852135ff1c28c50cb254a7971b6304c38ecb39a276d6ece5e0c575931bf8eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6d8355ca650028f52199f35ba15ac70956a70ebcb33c40d36d7e16ef33738e94"
    sha256 cellar: :any,                 arm64_linux:       "a3a73459debcb2a15097091a1298824f18570350073d1dde5d6c1aba25938478"
    sha256 cellar: :any,                 x86_64_linux:      "01fa8e9ec634bca2e4ada70e6332a404cbd3b0dd07aadcf9ac42af95628a9b8a"
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
