class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://huacnlee.github.io/autocorrect/"
  url "https://github.com/huacnlee/autocorrect/archive/refs/tags/v2.14.1.tar.gz"
  sha256 "054295d2289c61992ecd2c062d7da548ea11c620359a48a611a704825f0e482f"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ab69cabb4f51b1a43a05004acb0b0df755d700ee4ca1b22e17ce45cec9de9ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58b1dc7f80459a248df95c30d87bec86bdb0c3dbde2f12d3025b5751a3469270"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20a631ce121d6bc27881d25e91b3c0526d4841d8ac0ed73d91794f614806ebb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b79b592ba2d43ebb874c2cebae18f99633321f99ff0fcdd5c0acc718f9a5989"
    sha256 cellar: :any_skip_relocation, ventura:       "96791049401140fda0212f7b1a9b3cfa1ce71dc65cd65325782cd1ad5a4ffc2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5419561f51154aca0d67deadd182a3aae02096f3b7f004f7a4bd8dad96a34c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34efb48cb4d97a15b014c963cbea8970f0b38a8ee9073979bcdc34c2f8584e85"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_match "Hello 世界", out

    assert_match version.to_s, shell_output("#{bin}/autocorrect --version")
  end
end
