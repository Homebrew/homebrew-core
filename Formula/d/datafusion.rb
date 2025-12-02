class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/datafusion/archive/refs/tags/51.0.0.tar.gz"
  sha256 "e074a2c929b469fa974e5f7e08ac1bb90acff49f6cd6e124139f14286d8b5c0d"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caa6f3bfe8e0a6af578ee04eb99fa92f3d1ed03910ae77122e9908348f8605ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7bf22cf26f92e6983910bb98cbd6e4e73fbf5b8bd5a97a2dca8407a8da05c0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10a7676431c1ade7fa5a99b26ce5410ddaac7845f6d60c21c025f84794f322d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b42ff3001beac303df8d4d39992aba9686f9dd9dfa7a1af4c94776a6046f7ecb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5fad00b4142af54845b4285e609b249698c41a19433aed2ceb437d25867056f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f9bae16fe59078965b2af2f6c0a7d6c57dbc5fcd8151cd474e40b1003ca2da4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write <<~SQL
      select 1+2 as n;
    SQL
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end
