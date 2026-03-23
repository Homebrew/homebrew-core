class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.713.tar.gz"
  sha256 "95e7602e82aef1d326c8303210600e0cf0a0163bed921e991305e5e2075e3921"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff14a41812487b20873c68c4fbdd5916975b91481bf190d670dd08ebd4a9809e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec0dcfdaa3edb680b5789c4af8c8a6d741fbd0d04eb3a5feef277cb41d22e396"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04d550a580119ce7825690bf5214445eb8badede678344b27aad26db603d64d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f77e32a53ef8974e297ef4e058c9eec5f796522fb6a6f0811024dd30ef8fae38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e987125c94654afc73cf6b718c686901c77747bef6e6d83f626a4faebd4868dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eda19a926717983a213cf15e8552ab0c34c23040e5ff8d09dbb6961972ca918"
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
