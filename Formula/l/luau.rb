class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.700.tar.gz"
  sha256 "e0dffe07a4b27c568b9688916e1d97ba7204b7a4d487d0a03648c99b88fc8df8"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e016abcabe85302373f2a31b440c05259be9df82547a3eea947eb13bc3670cc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a1c5ef96c416af8ebcc63bcd7c078fb985b7f7f2c5d2784b8df10033a3b173d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5468a8b003b63e90e5e7e948037033e8bd32351f938ae7e96ad73f895c254f4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc67a5409931bdab63f8e260834a01bbbc9d85fd88c6812dff42617676e146f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8e01f4d6e4726ea690a762d09ee8f97604da6958e5145843168ab5d7c3db14a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fd5a8c08f3e8eac3b4fa0b9234472b2b98dbeb3ca3d9b66712bc00862c2a7fa"
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
