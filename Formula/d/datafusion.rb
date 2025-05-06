class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/47.0.0.tar.gz"
  sha256 "47d4ddba6708bca75e93c9e2955c3c518086dcc0e0deb10f6d285be14ad0a729"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a15568ea05c9e44c3d3cf2d2ad0ba99edd87f2aeb5ade7435328348d8aa3a6d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d16bc43308608858a817d893d3b65938109d188b7659da5405b499e4443db3e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21183c4ae865eff9ef9f75f75cec67ee4aea19aaba5c9f5d4e9547ceb6e153e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "073fd32c2e07bec63333f6c61e2df43881ab79943944d3b3bdbb5d2d8cd38d04"
    sha256 cellar: :any_skip_relocation, ventura:       "8516cc8dda3f9e45a445c2203ef5665dd5699885a614d34afaecb64d188b89e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df1093d35378b1c073ecacbf4498615ed1e57a0758de6f02fad3ee8f609655f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b9b048d833632e5ae314e2df8daa074c7a0734f95f9dcfb4c19b4e578c7cec9"
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
