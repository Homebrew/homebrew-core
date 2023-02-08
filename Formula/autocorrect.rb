class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://github.com/huacnlee/autocorrect"
  url "https://github.com/huacnlee/autocorrect/archive/v2.6.2.tar.gz"
  sha256 "550d94c3e465a0827a86bdfa23fa82c84a5ddf08fd9e9efb5e45f788bfa65b27"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1776e977122ea4914bb336bd94ffd144bcab152578520524906553214007927e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64ca92fd8f6a8eceb161fe09fdda7e69ce89f5ed512194c307db0c6656325883"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02fa2bfd8b1003c1edc8ac172c394ac13aea0ea3472f2f37108a88bc8c2ea1f8"
    sha256 cellar: :any_skip_relocation, ventura:        "28310e216839f847382a4b6e826cad606686a4a23dc5d97f06761ff446841418"
    sha256 cellar: :any_skip_relocation, monterey:       "8e8ef839836b44351d92af73f66d30ac68053ab967df259a1c7235316e4b34cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "17710fda15271fe2e04b5c9bf0c9663aa0e9a9440eae4407299ac4a9ded24c34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11e06d3ade6ddc9b5bb6df4904487864b28839ff4ec95a943d598c6e3b8ea326"
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
