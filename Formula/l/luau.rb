class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.704.tar.gz"
  sha256 "678193141db9b913edb4b0b35f511a469014e7bf1a35189cbcd2f7037fad71d0"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bb8db1f743f10a9823058a533a5c3acaee48ddb120e75e748f45b0772ca7ed3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d121d44d1803c5321c1ef27aeb62b2824557fdf593eb26f110a790fae6d0964"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31cace8c22d05df1c6afdd55e0f9da65b1365fde6189e68a71714e5224e13da7"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc96ecc7d10100ea5b31be8a7645d2eeb939a4b0168125a61c389a6905c78e44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f661654899b62aee13f7523592d46f2142c93a4fc3cb92fc88fcb56e3f9055e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f212a5cb44b9f6c9e8b5070e4fde6bc675bfab067a5074fb99074d25f0468bc9"
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
