class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.727.tar.gz"
  sha256 "a03896f1a55887a2d04dcd268f3c049724d728158ae0ac2b0bd749ea7b7b5e5b"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c9ad029f632b397388984e749fda8ec13302f971532cb8cf873dd40720be038"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cf9bfaae53412fa952c1fb5aba1c5e3068efb8a3c67b78c0236583f6328831b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bc848ff49009deb428b830c54274ee1e0509532a853008668cf3839d8037385"
    sha256 cellar: :any_skip_relocation, sonoma:        "5aa87679c9982b215073d1f050fdc1872b1f14818a1fc4762c65443cab5cd45f"
    sha256 cellar: :any,                 arm64_linux:   "c564ebe274c7fd5625c53630b4b2fbe3f0ec577cfdaa8755355d3ccc7797839e"
    sha256 cellar: :any,                 x86_64_linux:  "560396cdc8bed70b19896bbfc105cce43ee5ba01872e22d96df1b0d3a38c8f57"
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
