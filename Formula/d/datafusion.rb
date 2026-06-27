class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://www.apache.org/dyn/closer.lua?path=datafusion/datafusion-54.0.0/apache-datafusion-54.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/datafusion/datafusion-54.0.0/apache-datafusion-54.0.0.tar.gz"
  sha256 "1a7d449358a1c4dc81244a204650e100b9cf377f851995a1f13a4b4e81817cbe"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4733263ccf33542d003e29099a2b13e3e5f77ebc5adc70ad07720a1dae439b1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4e8bf28ea735003b43384d1dec6f7debf6acc69f5d7aeb0a384de299469d645"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b7dccfb3f552ab737794ad5492ead6c1f595d3db4feb46205890cd921c5a009"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d8bc97c58793d51bafa5a5698a34bc4f41837f4233255f97d00fb17f71517f2"
    sha256 cellar: :any,                 arm64_linux:   "71da2580802220d6b0b2b8abb49df591bb6541da6929f3150ba5615821dd0647"
    sha256 cellar: :any,                 x86_64_linux:  "44ed749455116a6fe1ee41b6dd2297a2e78d0d7651baf982c2986e6d21565548"
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
