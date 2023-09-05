class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/30.0.0.tar.gz"
  sha256 "a8c153fcb4ab38eb9a2642ac4ac0ecd74af8e2390415b996dd5b95159eaf6396"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a680768678a8e78b1f497989d2cebfe6cd9011cda5600167684bc23f22c19e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e51eae6830b3fff515833f63c1862a387bfb8e120630ecdb2be054583eefac2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6100b637d628453f0ca256365328d3a85167044def4dc4c33a202b00b97d6d5f"
    sha256 cellar: :any_skip_relocation, ventura:        "b4377c98973be4bb56acc4466252688e12bbbbe877f06ca87fa7a3b83efb4231"
    sha256 cellar: :any_skip_relocation, monterey:       "c8ba8008e2144c8abacb4278269cb5c262992a9e54f07fcd9f83308d594a32ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "449a44443fbea03debb186e93f86ee3ffc35e4625722b156dca4da2fd46aafd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0f58029bfb2ec73a734248d630b0dade9cbac1cc2c48c0ae91d5a7f9956fd32"
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
