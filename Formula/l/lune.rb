class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://github.com/lune-org/lune/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "73651a1e3edaa2c563d420d653906d2280c3ad8a92fb338a39faf95928508af1"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac62521b4eb426fa93babae1f8006bfc20d97b59f7866ac9de482cee42d38c45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "255bd8f549977d881abc1ff056d3b237669627b6d1415a141d7ea677942eef86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e8aa1f5b0a0e68da5258a032c8187a6ec3e7da016bbbd42a5403457935cb0e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba7e2791facd1ac39605b5aaf928a8334ba9da3eed661868a38d6ddbc9282c45"
    sha256 cellar: :any_skip_relocation, ventura:       "2fba0afb77f4b965af2315c00fc8903569fa434019639594f6531078f40553a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be022917922aab67bebe6690fdc9eba8ae60237e0769d4ecc90afdbd750c29ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "960d2c0660c5c5b431ae60d31146f68707f2feca2043c01a430329bf350db449"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args(path: "crates/lune")
  end

  test do
    (testpath/"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}/lune run test.lua").chomp
  end
end
