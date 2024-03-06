class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.56.0.tar.gz"
  sha256 "17d60e877ad44228c82a6bf7cb2e9811a773e74b7e1e0f51a5dd62d43085d12f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e9970ddaee0d79e1094bf285ab852b70c14788b68413bb498a8f3fd77e8102f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e54fdfff28b60ef79ab069c5867050c348b6dbe1fcdb11fb88b51e33b83fe68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13a78c44a6022312964b5f5ae48c052f6e36909a7a911e8e43bbca4256a56817"
    sha256 cellar: :any_skip_relocation, sonoma:         "55c4728d52d684a88c674ceb72993c1b067baa6edfd6999fa2a9828499b0e910"
    sha256 cellar: :any_skip_relocation, ventura:        "accee3109fe879c760f221d361218b935543e66865e6dd07a3a08f4c708d01b3"
    sha256 cellar: :any_skip_relocation, monterey:       "5ed3dee2adaa8b3420403a47d517fdbd57f0ecb606f2d6aee2dbf585e94dbd95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c895a5121a05849d58802293b8705de5abe6da981d0679e2f814271578c297d"
  end

  depends_on "rust" => :build

  fails_with gcc: "5"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"a.py").write("print(42)\n")
    (testpath/"b.py").write("print(43)\n")
    expected = <<~EOS
      b.py --- Python
      1 print(42)                             1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end
