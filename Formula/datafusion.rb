class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/23.0.0.tar.gz"
  sha256 "17e2aeacd3ce836bac8919b0e9223a9d7d04218db03eb24ecdc42eaf55fe18d8"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c92be198587d48a5e32c59b2e563808739a1028b88a4923a0c786d83ff94a1b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa805e8b38e72113ffef618cb9beb0eedab7836f143b57ed9ecc05ece4bd748e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6df4d07f320a2a9e52e18620124be96ffebbb8767b91913236161fec91f49c79"
    sha256 cellar: :any_skip_relocation, ventura:        "731340c825d5eaea7d27710eae4dd2b75ee09aae8cb636ddfdd25ca30d259668"
    sha256 cellar: :any_skip_relocation, monterey:       "1f7eec97330b5e1424fe948fd60f909ab1154b9aa531ab4c780339e393346f3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d584829de2c21476f0665fc42a9d081a78ea86193fd4a5699155f4cc057ebed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59f7aa92da5514ec7196e9c5d244653ab441efa4f6c10b163d24d74a5843d4e7"
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
