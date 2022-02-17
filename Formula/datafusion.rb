class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/7.0.0.tar.gz"
  sha256 "476f5827d6b9a7e9009e87b7545847d26c71404eac4ec454c413aa6ba878bdab"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f9cd550ed4ceed3a5d506ccb3fce520098ec9bcf9041d4a66485a9ad911a5a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8df07f027c6ec76d80c98a2f7973abeeba2fa93e4da507263ba53e991c23b401"
    sha256 cellar: :any_skip_relocation, monterey:       "484aa676127c846c5587b95238efe2fcb81c5d6dca4e0c1125003286ca420d76"
    sha256 cellar: :any_skip_relocation, big_sur:        "004950695646c92793af61cc530f1ab54fe4d3112ac534059de00c1e73bbb53b"
    sha256 cellar: :any_skip_relocation, catalina:       "241e4a80cc759226ea09f207fc5b9012c6bc8bc2cc33ca264c08268d67d433ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60401865332cea1014df4081786cdffbb801750be1116d575f622b7311121f31"
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
