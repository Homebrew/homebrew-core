class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "54ac66fac30a1d28c54f19716215cf4256877c69964c1c0150c3976bde618b93"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9f78dd3539265e37db02cccc2247c07b52e19c41d5e08b6bacda3143e107cc13"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d37ff64edfcc2f11468a4f962b47b572efd4018ee38a6836436efbe3e9d7010"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c8cc80e3fa08e8fb2e998ca0c62db60ada9a88b728cb36d8a0d5132963cb735f"
    sha256 cellar: :any,                 arm64_linux:       "b5ee914f151ba112005b3edcc0851b1cd11cfb04bc35a0afd04d3e71d14ee0d6"
    sha256 cellar: :any,                 x86_64_linux:      "d19b747393180c9b93a2eb9b6f8bb88918f7797a74e095f89ca46f03c0361e70"
  end

  depends_on "rust" => :build

  conflicts_with "json2tsv", because: "both install `jaq` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", pipe_output("#{bin}/jaq '.a'", '{"a": 1, "b": 2}', 0)
    assert_match "2.5", pipe_output("#{bin}/jaq -s 'add / length'", "1 2 3 4", 0)
  end
end
