class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.647.tar.gz"
  sha256 "0fe258a9854e937fbbf3ad8b3d56ff3c1879578cc88ca1f52ef7a84b98312c62"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "851e44d19014c49f5f09e6f35d26d4fe87935e4228b303849e85b133754d1757"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e36e009ec2eccd09e3c9d634d7335cfa9e5ed3d8551c1d8bfdd9fe9beb59fa1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01d23a22f762e4d44b3f859a0eaf79c76f7041af550624b76f7454fba8e2819d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1814754427e519055e459d13800b05281928e8113a2eeb252d1df45737cbcf13"
    sha256 cellar: :any_skip_relocation, ventura:       "8d5ce79e80921e2cdc855559d2b256786ae2fc94c2f9c714d0f458715b11e3ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb0706924e6ff026b1555dcb7a59f71ad3e285b82f61798a5150ea707b9ccccf"
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
