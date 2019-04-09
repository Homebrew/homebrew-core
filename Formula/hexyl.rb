class Hexyl < Formula
  desc "Command-line hex viewer"
  homepage "https://github.com/sharkdp/hexyl"
  url "https://github.com/sharkdp/hexyl/archive/v0.4.0.tar.gz"
  sha256 "7450d8e0d382a9f78c5fa6de562359749586824d74c708c983da5a9c032bfd43"

  bottle do
    cellar :any_skip_relocation
    sha256 "e05935d8bb534362f8f0c695084550dd39cac6b53506131e16b5e41ee8121dc8" => :mojave
    sha256 "a39ed75bc657df2dd48d78a4404619ecfc3920921e5668bd50e78125809696bb" => :high_sierra
    sha256 "af20c59d4422118f40dfcb768d458c43ed9eff46c3e0fa11e589cbafe0cd1331" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/hexyl -n 100 #{pdf}")
    assert_match "00000000", output
  end
end
