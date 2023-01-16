class LuckyCommit < Formula
  desc "Customize your git commit hashes!"
  homepage "https://github.com/not-an-aardvark/lucky-commit"
  url "https://github.com/not-an-aardvark/lucky-commit/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "3b35472c90d36f8276bddab3e75713e4dcd99c2a7abc3e412a9acd52e0fbcf81"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00589a6e96ca40097e2ea94c8eaf9497ee31eb2b9ceb4fff570ad457403c74f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afbb8c5a16be111fab8b75cc681a1e9c6168d2ecc4c21971dece357eb27151a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1dd946763d4e3f0d2e2d0f4c229c77073517d77e34d3326f49ac3320e3c0a55e"
    sha256 cellar: :any_skip_relocation, ventura:        "cdf01822bc921747d02b526af035ba5c0320e93758dada741fa52804fa217277"
    sha256 cellar: :any_skip_relocation, monterey:       "92b4016661dad378b653827fec88044f9fd02d50b94123b9803b1817bc3259b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd44bd8530240c80bc0d9c1bf1e7976c51349fd985339d7d04d743aa6435cac0"
    sha256 cellar: :any_skip_relocation, catalina:       "d01adf9fa8eb3309a45062fd79075f4672ba3633ea45b4ccd9f0460b4182e413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbf3f8c0e066f365cdbf0d5491fcad47729f1ead95f7bafa9cc282fe2e46ae11"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    touch "foo"
    system "git", "add", "foo"
    system "git", "config", "user.email", "you@example.com"
    system "git", "config", "user.name", "Your Name"
    system "git", "commit", "-m", "Initial commit"
    system bin/"lucky_commit", "1010101"
    assert_equal "1010101", Utils.git_short_head
  end
end
