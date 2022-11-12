class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "695ac97fa08d64f7e7cb4e9a49b721d26007ec9f75026254fddc341328f87b26"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f94ffc500014b4e9acca81f7f0d5b3ad88204b2796aa7234ddfab071929c457a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "398e5b6a24e16aabc2dfc8b5a92c7362dd62fc400108493d4e29118514af6003"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f921bf6c5248698ffdc8a3a23ded3e0dd28c27762ecaa228f7c0a3c220544f06"
    sha256 cellar: :any_skip_relocation, monterey:       "576365ce92bddc5a1d66bdd558735e1a8ae47e2b319e87d01b81c7af42cae696"
    sha256 cellar: :any_skip_relocation, big_sur:        "28213fa222287b94a2cb34fd77427a146c9168272fdbfe1e2bcd143f47730ffe"
    sha256 cellar: :any_skip_relocation, catalina:       "6c8bc87a10447f79523fccb342fdeb17ff7baf84816cc535ad8a07faf1f7ce5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cb59766be691170954a65abc1bd561dc6c95bba63bdd1a28a557db894b50158"
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
