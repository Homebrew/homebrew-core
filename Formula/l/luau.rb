class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.664.tar.gz"
  sha256 "2e571be720d3c75f551afcbd5506693bfc4384f72f432a2a4ebc1d082bead0d8"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c82b277959392582ae9035553b2634602df568f4afc36126ea3a8e4f7e22d38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "291ed5523a9214573711dde79728556948ca18f1bb872059d62e554aa31872a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2bea4faf936d22ebbfc116545e73f629f7a08ba69383f56e513430830dab778"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8bf17695bdeea225d9cf53ab95061a61c606afa43cda0f15c5665efd6d5b3b1"
    sha256 cellar: :any_skip_relocation, ventura:       "12ffad03ace265df6390a6c608fb10213ecbca00b4e74dbcfcc5ddb9f38d3f03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68aaf1968cdef22e84b991633651c6f1148832c0c1e7b37a14e13980adfdf83a"
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
