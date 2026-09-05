class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.737.tar.gz"
  sha256 "767b872f084518ca9a79b021f83b40e6a051be4c1f91dd712a949417a4e979c6"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb938be2d09d013be540b2c3cf4f3ad10bfefe156a727cb0007bc697ebcfc45f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53e77c7a54997fceecdd4673abed95709c053d25c3be6bc4781183baa1488fbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "526fc15dfb56079047d3d5a3e90229103c7d75b1c5bfe72daf97f747ef1b2973"
    sha256 cellar: :any,                 arm64_linux:   "8bc0a27c967df6ffd20c0f9753cba42fbe4c5d9f352aae6c7480818df4e74621"
    sha256 cellar: :any,                 x86_64_linux:  "00d044c7bb4f2af1910476310d23c7c72dda4dab0cdcf96d88033387acca674e"
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
