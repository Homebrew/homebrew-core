class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.735.tar.gz"
  sha256 "99151a646e12803c5131592d2e2db4b5ef5d1b925e346aa9cf436ec9c17a820f"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67d58e0b61d2bcdf863f94fa2b67635252eb15502eb4c66cd0dbb78fbdf3991a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0947ab0ce4fbec7a60fbf139a2bebebedd6f69c382f76ca16d5761f1847fc39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffc2a4f52492b041128b9ca116e446f8a6c719dbb082765b3e78f5d1b7c9256e"
    sha256 cellar: :any_skip_relocation, sonoma:        "61d2389d7fe049f436245469eeff98edcba541dd628ec7e0299589fadefececc"
    sha256 cellar: :any,                 arm64_linux:   "562ce16b27d0ea065cea7f2dd6cb3b4ff1f2d37a4fb266b35bb5f7dfc45201ab"
    sha256 cellar: :any,                 x86_64_linux:  "1f0a81bcb6a9117cf6b9b6662055b52aba3c41e8d2297687ccd2fe8ae2e88ca3"
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
