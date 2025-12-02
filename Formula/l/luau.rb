class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.701.tar.gz"
  sha256 "90bfb3cc8c04e103a5d34eaab882b39545a991fed8a5a198db2b686945774473"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4e89352b689f5ee2a62df1d61e76ac6df0d81fc40343ca8c9b5728ccb9163c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a201a258869be201c20442e77ecefd2d093636579412462c44c80db81d5d037f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d824bad3a8d3bfa8ee067a09e65fdf2821b27e96677bd59f04dae1d9a97c607"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8e99ac91f739205f8ba37eca9342e98c612b1c7dd86402a3e7fb19d237b2ecc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec794c9bf98ff7f93f59bbc78912f7193c193d58930cb0d3354fd7e995ebfe76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "063d842447f02803d36ed98c1797d687d2eb5f7eafff79eca9c6f0cb8ad80e5c"
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
