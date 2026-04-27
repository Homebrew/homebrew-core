class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.718.tar.gz"
  sha256 "428cfd235c3d1d0669029d2c2b4abce306bed3bc1c5c1eaea3ae75aeb32d2cb3"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a37b3a4708032379b18e72aafc4bd4c5e40791e9a36533993f33c9d97f13999e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ab91c428a638d8afe38dd8434716c7ed8022e69a1b5849f99eb698c26f36252"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a439d10f08a65303f5e2939cb758325695ee42103bb817c76dfbd2014c56e6f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6731959386890b7223fb1a3f046daf77d48de6a7204923d8847d7679283c49d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f8d99badb1fea9cb5761a9dfc736b3ba45cfce5c85d65d1ea39f3a0b6a78662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3b30206f1422ff5d64620d6fd708dd289afeacf198f5c4888359952098dcc6f"
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
