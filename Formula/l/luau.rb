class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.648.tar.gz"
  sha256 "0177b98d837545556a032b35fae918ceb07d1b29adbfa163a35bf2fac0e996ac"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df25ca7fad811c2077be961cf6ed7a1db5c0ac9764d94d4a9c2b31cc7e31c7b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1bb10aa717784327ce6b92e0623c4fcaa171642dfd2545d92acd8aa61c00016"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4f608a8842ff57951f041e1d796760457813bb39de05b6e6e6b207406e9c56f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcad1eef24921bf3c888227123c21d0c964d8d7ed222327e710eb52f6569e9ca"
    sha256 cellar: :any_skip_relocation, ventura:       "6a0ff783570722948585f9f79bb029adde0304157c58747538a1f95c4bc3f559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1e9bcc6ec1859344c8586e10405db1140ffbd011a5b1546399793cf1b2b2dd2"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

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
