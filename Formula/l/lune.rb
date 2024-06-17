class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://github.com/lune-org/lune/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "ed272b39ca8d14312d4ae5270165d689465594595fcbe0be6d324056cdc0daa9"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f583a48ad73cb87a14a51443aea60624abb1781a48228179825c2e86ee58e5ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bab482c4fd822f5f944e20c8904385ad7fb924b62918825cf30a723a6c55f48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25071819d8eaf5c15d67e790d9616967d513e13734c84f62363fa3ec6df8d4f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "60b32bf7aba63c8d203ed72bbb17bcb636313589ccb736bbe72fe90c8b03f019"
    sha256 cellar: :any_skip_relocation, ventura:        "e609f86edc43ad741444877f57e867b273c983c73a1f1f5c2a9db808b3e43fd7"
    sha256 cellar: :any_skip_relocation, monterey:       "2be0260288c5ebc1598d74e4a163a434929999d68107f4f920e8560bf46da8b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d156e86bf1797fa31dfa8eb0376351187533fa78baa32c4205f235af99288d2e"
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
