class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.691.tar.gz"
  sha256 "ac4d630d475b352f96ddc511773640a69f146e30f465922e8ce406bd9294df4c"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c65a1b70b688ddc3bfe0453de98fdb6c67183160cdc7314bc62407db5c43c11a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f8c05dbaa388cedec2d7545fecfe82968cc424391d55bd0101bddd85bf103f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "754f6664a90e4e033a048ecdbee36617708166391ded362043c86cbe781ecf81"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b2f5febe72dca9b24b43324b26ac23cd40048b91455653727f13bce938b3c64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d55bc8e17d2aa832df7fa91bb51b734f2570fad8f9a433a9d488518b4c6a761a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a923a5e9abf109f91b1680f3d9bdd8d6fbd48d8c2fa4c5ca5263699fa0938409"
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
