class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/refs/tags/0.598.tar.gz"
  sha256 "a2bab4b513fe5f2fe174c45de4807846e6ce83420c9ba7a34c81c48b99e01c98"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2dca09a517ffc3bd5a35de00d9440033f53641debbe84259efa2978aab54ff2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f2d11d032e75bfac901fbfdf81ad8682ef57df1eb7445fec6c80126b42f8312"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e0fb4a1beaf32e61719bdb752e92f1dd73e79f070e96c69899b2b9e9014b5ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa03b03e1cc5c48fcc241b0117ef1f4b47b9b16d74e4b555dde5aa09f95a2b8f"
    sha256 cellar: :any_skip_relocation, ventura:        "50852b3e177c2e62de4e8fe1d14923545c28a31c73c1d13eb9b1793367e02bf8"
    sha256 cellar: :any_skip_relocation, monterey:       "fc06ec1b14ef92f2016a3d22aad06a135e214e9259d53c330e270b95bdcfbc4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b9b81d5bd2b50c05538f457093023bf12386d491472fe2e4450d6758854d0f3"
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
