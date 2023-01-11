class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://github.com/huacnlee/autocorrect"
  url "https://github.com/huacnlee/autocorrect/archive/v2.5.8.tar.gz"
  sha256 "9a06dadf9e5d4032e81edb44fd6e0b61e70bcd01fc094b9e2b4861d8cb03bcea"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ec7ac4af5e7bc393bca0f858f05c86f324b68074be10489705ef20d147854fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bef2a1d707b9274c48b57875b86753aa85743af7d0e68f1b72fa35d1040fac7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c10675c5ae8003d83bd9e7f6aeef77022a27dc77253b01a82ce438f7ede31f5a"
    sha256 cellar: :any_skip_relocation, ventura:        "81969bf20183c2bcfe29fa5c35a3979391b93d60352e228abcf9f006e841621a"
    sha256 cellar: :any_skip_relocation, monterey:       "8d8206f45a7e80657f68872f3db0ae96d403652730102459adf6944e5578037b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6490ff14028fedf33b39818be4c890e8cabdf038114be5bc8e33f52667565c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fd1cceb02ee5909823abb73c411077501907a4bdf80f2ddcfdfa3b26e27290a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_equal "Hello 世界", out
  end
end
