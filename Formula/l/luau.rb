class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.669.tar.gz"
  sha256 "f1d804f00d78e26b09fb998350c82d989ee1136e0eeccfbeba2de982a9e47311"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e623f651444469e178083e890e3b80b522f0b27313496630e9080c5edab3637"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c629b1b416b23494b5c8a52323f4cd3e27e339543395cd64d6c5957f69239ba0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "682804fa565b03b5992596f08a2239fd20ac730b37fb54cff0edb88b80eebc1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "72fbf002b1c6102d78543b110ce35d62fb530af55d3ca4fa44f44b1c921f3992"
    sha256 cellar: :any_skip_relocation, ventura:       "57ff462aa3732267bf2110e528d8749f1a5bbb482824251071f79791b707c784"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bf0c6ca38831d11ee06470cfad999a2f8c2bddbf8b5431166fc4397e4f7cf52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b9eea9af9af46a9a789ea82a5f75deaa3e2083f12db1ccbaf0d3ee2908df3fb"
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
