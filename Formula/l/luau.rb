class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.712.tar.gz"
  sha256 "9b5dcd3216bcd80de200006cce10ace849481fc7853cee5d15955ef532d2df4c"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d368a678f644fb04895c1315201925661a65147eb8f0ce67ea2926e7951e74e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cbb473f18fb772760a07952450386db1045be17fd3d348853c98846f8460390"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9b8c88dd15b48df6988d84c3622c14e885dc9e945b0fe9d0bb6c209c9dcae72"
    sha256 cellar: :any_skip_relocation, sonoma:        "52af55adde2978ea9c325343426738ba0fd1a91f206b3a89a1eb14deb1088815"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48fd2666097d8c73fde23db98789d70abb79c206f35887f4c9940b235d64d628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae1d86e21be2440997f0d3e77876b946b6a95c5b098b57e59be1875bc786c467"
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
