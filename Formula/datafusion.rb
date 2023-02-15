class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/18.0.0.tar.gz"
  sha256 "8bdb695f0db084c36f9880f13517408fe642aee6b94c154427102627a37d74ba"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad3e1c806b727cba54bf29537171e29c7b30ed5fc7a13a4e9c03a6e820477c37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1690229454bc351d25077bf203a27de252a8299afd9125941327b9a29e81ce82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67e33c791c9a6f3acd51b3cd0274f80563c9f9acabc3b9e986f4efba652ab2fa"
    sha256 cellar: :any_skip_relocation, ventura:        "5251f1a17071058099d4caead0946afb70e03716944dedf119058b779cc14825"
    sha256 cellar: :any_skip_relocation, monterey:       "230b943cb7df92ca03dcaabcca73120bff105a383a6bfc9ea484a38e733a86b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd381c070f244481b0a2a0e6e95d95cbba846742cc09dfd8e48a8f2c099898fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea60ed0f29fd26a1d7e0eb8c1e47e2afe1c1ee6879fdec1cce3b0cd67055287f"
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
