class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://github.com/lune-org/lune/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "e632a7bd469c018eff9cc7e957f77f790909590b49914820f32d8a73f617a026"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34efbb259ae07923b823122aa53d34d7453a03452ab7a17014cc4337cfce02b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6aab87c8c79669e4bac7c0a8bde87c2cc2a6ec1ceec3320d8953472a4f404cd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48a7404fd6fc52c4f6c672bc9111d2435bd387f72fa3e17418fd2431919d4834"
    sha256 cellar: :any_skip_relocation, sonoma:        "674ee157e7349e8f41cc9a4f6e794ab9938035f0b05650e1466d3a08cbfe9602"
    sha256 cellar: :any_skip_relocation, ventura:       "b036a358c5d7789cc59b67771bef3e356ce89fa2887d70f80cb5b1f90469b586"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5f41824b9ca4c89accbe4decc7f48a02c69719213ca68044cc8843a89a70993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f83481727c0f7af3cc7ecbabfa05848b2d33ba56f62f6d520ea3e47a382445cd"
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
