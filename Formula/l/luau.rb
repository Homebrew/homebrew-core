class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.719.tar.gz"
  sha256 "d6901dee02f1096de1e61f3a481f29bf5892a4b29bf9eec52add8c0852f2f144"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6f78aea148677efe5d44958bf72209ca7a91a1ea3b6dbfbb484b610183267f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6741bfa7116400e3551e3f74a563f3075fd5e861586c0d22f5efe0344e07c04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa4130b227b765e50d95a1ec87680569aa1c8a6e6a75fdfd232baf927c64063e"
    sha256 cellar: :any_skip_relocation, sonoma:        "47cb2510b7c49481ad1ff88237a22fb2a5731217e6c9c5ffa12c707947162cf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e47dfb84abab6293576001bd3235e5ffcacc5528c9809a07c90e20ec9a8783c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f42cd3c25a01d5333b1d27e87b498393e8ef63dca35df5836d9960039d7c36a1"
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
