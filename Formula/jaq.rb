class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "ea54e2675ccd7ea9fe900343cea9263582a519f157fba6cf1d54f1e4e6718b99"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4ad544e0c905a377a2ec2077b896b735c7c49183d546752b9524bbd16549d49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a70af3f51d4f74926a2839bcfe62c53814f828529607828a1e65ded358c5bfc1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "135c403478d36c99e896feb36d7f83254c10911dd8ccaef1b7d629e137ba0607"
    sha256 cellar: :any_skip_relocation, ventura:        "eda0466ba98f8640b00b0caad49c234853044019c1f7610b90e21c8db52f62e9"
    sha256 cellar: :any_skip_relocation, monterey:       "f7a3ca957befaf21b401955955ef4ad0d2b61596a2fffef74f48b75fef5c955b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0387f0421d669ebf5d0c17ca00bbac31553882b7d88dbf82dc481373f36d40c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4ad6f31601473dc845517d1f145002ef77c741ffe8c2fb46656000136d7de71"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}/jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}/jaq -s 'add / length'")
  end
end
