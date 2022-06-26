class Csvq < Formula
  desc "SQL-like query language for csv"
  homepage "https://mithrandie.github.io/csvq"
  url "https://github.com/mithrandie/csvq/archive/v1.17.5.tar.gz"
  sha256 "6ff04ed951a099fc6aada13c920b8b5bcec1437015cf315dc090293694b5d0ee"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65307d3fc0f74de021015ad233985648f14798c2f1b99e1d38c968758fdabaa2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "271530c69eca5f7f6896972a252c1b86f58754c1e2b676879be68a95201ebc45"
    sha256 cellar: :any_skip_relocation, monterey:       "9ee4b55aa524c869fda5d86dde14c512cec65fb6ff315ce2b45dd76631b2cfcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "b93c374234793c2330517bd008f12a37f5074f52e382b571b6879c88120c162b"
    sha256 cellar: :any_skip_relocation, catalina:       "0b63dcdc09115f7d4d21db91f22f8661c1f487d5b57c78baa3c191be0eb60f80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c4568b441b998d2c49eb0f38596ff50d67b60dbcd1fadcf140424d41d3f5003"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/csvq", "--version"

    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
    EOS
    expected = <<~EOS
      a,b
      1,2
    EOS
    result = shell_output("#{bin}/csvq --format csv 'SELECT a, b FROM `test.csv`'")
    assert_equal expected, result
  end
end
