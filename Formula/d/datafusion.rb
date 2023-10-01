class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/31.0.0.tar.gz"
  sha256 "32986c77fb0b6538db4d76e43e0135a209c6fa37e2a790e05ff2a5c99f726434"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d201fe84a59decdbcaa1d32256719b9e02d5f42b599b5dd7573b21b21d764a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "706854dcde5d7f7995e37acfa9d9d47a91b3ab985824d34ed0d2166f3d382cf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca49f58ed4927426562d2e999799a5e638846888001d0c23e95027c0ecbd0163"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b429943b6a5fcb4086cd8faf0237152f5515ad796bfdcf271b5cc3bc5ee46cf1"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f6d7e8d04307afe46b1b3137a04193f22fddcd5d561dec294e4dee292ff9bba"
    sha256 cellar: :any_skip_relocation, ventura:        "231a19c5a3567da9b29d9266e5c620cdde498c9321d6e886c15c6d713fdcf866"
    sha256 cellar: :any_skip_relocation, monterey:       "e8064438cb75fd61b15e909a744b886aac944e18a810ab883fc3216662c21f94"
    sha256 cellar: :any_skip_relocation, big_sur:        "d04ce2741c97727b5aaf967df3cc2e4402d5df8fffc66f50905cbb62ec72428f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77ec7cf5c9b29beb65fffb105c2be787934047683544c35222c4ba93e4416922"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end
