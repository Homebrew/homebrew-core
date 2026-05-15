class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.720.tar.gz"
  sha256 "44607153273aa3e013587acba28d354cd678d8e8ecaac82c6b175348a33f17e7"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb3c1fbd459d1b2a75c7d766f19c821c23cdd7aea743d193b487bc428dbdcb69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "028a24a9ad7ee9851982d87ba059919f9a02dbbcf10bb898781b8c16381cd28c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70c7e73d8459984c50830f994f21728f9e43fedabc4df289d9d09fc5c9e40f70"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b4ffad0789205f140d5ee90a8f702a1b88f9e2ada95963010c80e331fc44ba7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8b253afa2b0c98daac894a7c07f6172bd9a22ef6618c7ae4753b10c3af66c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1828d87917d3694d16be7e25fc44bd4a9a0dce186f44f9c62b69ce70acfaf062"
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
