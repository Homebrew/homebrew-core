class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/41.0.0.tar.gz"
  sha256 "c4182420f593d81bcd0405fb1000d7db108972ed08f290761caa9b5fc4e5d901"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ca30bc0d1b3a8d853cd37b88ec7716ac0c6872fef390ee4f6735be373505b2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f5c8c62fbcbcb99f4aeaa48d53cfa44146a59f77726ae0c10aff21520d493ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af0107207e627d1ca01c83cc5249a9afc331f8ff1e16c701fd7ee1b49c28dc4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d09c5624a61d6bbcb5d5a598a7539c79552c9985a462075971c26a102b8db0da"
    sha256 cellar: :any_skip_relocation, ventura:        "1f7db17d25f95cf44ca0357ab0c571a39b778ca4ae1562f00d0143d7aa11af71"
    sha256 cellar: :any_skip_relocation, monterey:       "967c4b148b19c3205ef5950ab73bd00641010d0d1504dcd31ecb9edb23039375"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93913045663de83eb028e7a2e38c7d4c909bdd13db8b72360042e8297419314f"
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
