class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/datafusion/archive/refs/tags/52.1.0.tar.gz"
  sha256 "8c39f89cd2ae6a1f5e1c98e67ea3d128d5ebc4fd209a73a038ff97de49506442"
  license "Apache-2.0"
  head "https://github.com/apache/datafusion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8ca6f44ce3eafc9431874529b29b050217910eb33b0f5cbb50a931cc11e1976"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "470789be1b2aad0145fe7c12d65022433ff34ccd0dcf9404f91f56bd0b0b6b68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9eecc5f5f813db119dac8608ec8e21c0daa195159c654fdc49a1e654de80ea7"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc144670d439c2ba3fade5bae92fbfc58b2f48d09a7d2abee9a5d9666fd9390e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec39bffa8a119f005bbe2c1b9347c93ab27c4196c3fe9034f440869213ac9352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "917cafefd9d3cb4ad8366da182aff5490f032093460630bcde5579cd3ea9a40d"
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
