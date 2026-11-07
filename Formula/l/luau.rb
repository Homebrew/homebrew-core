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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4f17e66dbe1c1b735628255f8bc4ee265afd3ccd14d3b2df89e222e19e572745"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b17c855df1f594fd7d9121df2453cc15358a6db51b92a9cb593562ad8580694f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bbe56e11823f2314fd6201b0a3edcd6359831dd4384101b41ff9ef140d0625c2"
    sha256 cellar: :any,                 arm64_linux:       "4ee90bda89bc74875fff7e7fc56e60e1fececf9a0ca66f84dfe8d1383b967f10"
    sha256 cellar: :any,                 x86_64_linux:      "3ac6f778a9833436a258668345962fc7278ba4bb3d0d8d8b10d5382009f12a67"
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
