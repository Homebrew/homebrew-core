class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.708.tar.gz"
  sha256 "06db02b4cfcab77fdc6e83c0967642f20eca40258bf97cc95d87dbbd8eda4c43"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0ac5037991eb021187a22a25e82049ac1855d2ddc7af1317b6b8ef482759212"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fafd663f687b70330c6194c03d8b0c32383e6a9de48df4dcced39d212edac927"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "387fdd8919a7bbf5611c6818c67b187fce4712bc6c6760b874d1fd56df85294c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ede4dc66929db3d65e2215b42bfbb660073116855ed54956349ddd05d3aa2d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29142ba70fdff032ffb097712686fbe43e28293426e4a01809fbd3afbbb414aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be0d803d6a6966a5b7793917919a8e37be13e4cc34f5f33842512a1567df464e"
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
