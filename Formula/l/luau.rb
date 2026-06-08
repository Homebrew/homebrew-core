class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.723.tar.gz"
  sha256 "74bf6b8842e00d236d390f9431205c73d0cf887c973f9d0656396bbf1eb987bd"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3143cc05c77e54570dc4be0823d0225a4dddea68a487af9119105e35e10c8473"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9c5807e53fa9912cee206119ed06d3df2b57354be9e9c5207712f8703dc44d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2dccdafc69360dbbcecd3e3d0de3f4f3a44dc46d897b7ef51c2204bd7d522fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "7821b62c1f9b7d2aacc8fb7f65a7a9b652ad6aaed6c4be12c0b9f6ca4f71a38c"
    sha256 cellar: :any,                 arm64_linux:   "c5fe8cf839c3d4f028782957083026847335a3344419192d9c2b1d0bc88d17c3"
    sha256 cellar: :any,                 x86_64_linux:  "0d13d29c16b8d1bb96f556709efecb33ece81bdfb47685b8b01571c8eaffb881"
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
