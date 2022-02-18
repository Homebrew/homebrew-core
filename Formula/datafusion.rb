class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/7.0.0.tar.gz"
  sha256 "476f5827d6b9a7e9009e87b7545847d26c71404eac4ec454c413aa6ba878bdab"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66765a720ec6e9aacce30eb0c0d50187d1b5cf8eb6be6d5e83222c3411ec8ec1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25d3f814ef04abe64708999edff4d04a1f819a695b2ba0dcd1ef11004e72cdc4"
    sha256 cellar: :any_skip_relocation, monterey:       "2e8ddfcd30535c9a778537250194b676d58d1e41691aa2171072775e0397ec60"
    sha256 cellar: :any_skip_relocation, big_sur:        "19106162f5d8a6cf63e407c6c794a5dcd2711f683fbcb63781639f76a2851b33"
    sha256 cellar: :any_skip_relocation, catalina:       "a7d586f1b2b29864993c6612245b1a63bd941153acf1d0b70d1d78f9e31a3ee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0656c06e51341e962608450facc57dd7725a6768ce0f97f0f8680d6f4a730795"
  end

  depends_on "rust" => :build
  # building ballista requires installing rustfmt
  depends_on "rustfmt" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end
