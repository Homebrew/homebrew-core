class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.716.tar.gz"
  sha256 "7af19fc23fbf3919ac86fb02349c1e2c55852374ccf7be9864d419802f9e31fe"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77e5e544c71f58ef874ede0216c0ced7b4db590f357633cf4a300410caecf00d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d34ce9102742712b5d2d60522494ace07d286cbc02341888d36f20097e71e3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efebd29957f67887ad46da08db9fd1127044b69db703ef0fdc803fef4094f4d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fea55de063cf4153a1a2ed5d7841db3ff3d501b9960aeda0dc2b8034b9e963e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf346c7efc7cfea0eff6abc8db96e22cf110ce088ff6b7bc304194bbeb5b3d9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf950d6f0602c133a911454f77330d4517dbdfb051467048d47570babb7fe83f"
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
