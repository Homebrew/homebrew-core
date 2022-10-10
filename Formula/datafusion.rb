class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/13.0.0.tar.gz"
  sha256 "c68ae32b7d7db85e1f7e839f14929b6e4c4f813bef8a8bd87a03752707422d6f"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83680081c48190909c6a5f522bde19e3458d238a7de8f6bfc0a70e97f8e873cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c9b9996f1d917cc33b7a03638313f8fd67a40893f7143b1d4e4bb5b9bdc341b"
    sha256 cellar: :any_skip_relocation, monterey:       "8db2ae193c60e950e3139c0050edf875773273df2f6b30be86b0747911aac243"
    sha256 cellar: :any_skip_relocation, big_sur:        "41019ff5b78255bf2110b4df6358461b58b84d414419566daf2c2c63405affce"
    sha256 cellar: :any_skip_relocation, catalina:       "36842a858a6247a16201f2d04a7acb39d33c3fc8b40b1298be8ed4fffae032fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "270b0f9e921d33319e2200a42568a7d4f50fb9f5edc63e4227732da64c8e4e9b"
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
