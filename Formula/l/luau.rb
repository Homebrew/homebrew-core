class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.743.tar.gz"
  sha256 "be23707d541710a978f2c559c069e22ba9c7c449e07d60472fb4e074914bc91d"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dfe064fe7fc1499bd42ba5db8caa99ed70b36dcae623e76ed4f75a401d5af2a6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d69519d0522947c490fd052a592e2694d6a4f962de84ccd4c7312aae86f05e56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "750b001e0bf20f42de6c37ae1068dc767f1c03ba91970d2bc5df7239d14e62e0"
    sha256 cellar: :any,                 arm64_linux:       "eb55e093551fef71cae58537b90e9571053b05dca2ed02a6ee54d0052290e5ee"
    sha256 cellar: :any,                 x86_64_linux:      "471d6ef0a8ebe86849ada61b80e1ff535297804cf44e061bd9a99d6595d4a60b"
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
