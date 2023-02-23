class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.19.2.tar.gz"
  sha256 "5d508ea6374702f04f4b21f6dfb3d287922d3b7d5860dfc3fce2366128f371a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c22afa5fd64f5d933379846832a531543f5f685776c5b8d6ad02479ba40a9b51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27c87dc4b7792376cc83eb19232a8e10ad3e736f39b697d94a4b2f109aec82eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83bc90af16d8a4c17e646ff228a9606d5657e8ea13db943072ef351fa2dbf7cd"
    sha256 cellar: :any_skip_relocation, ventura:        "2a2f8434210b098becbc69e2d52d9ff9cc2b7ce2dba24bf83daee36fee3740f1"
    sha256 cellar: :any_skip_relocation, monterey:       "6b414589cde3e27b8c90ab6629ddcbf5a691bfe3502f5a67fefc400d77b8a22a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f677208a091b82a7216add1792553b7f23f1a0dba803bc999608a2b034c1d7b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c4bdffa7393bbe721579b09bdea02f5b36b6d724e233a8692279a054886ade3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    expected = <<~EOS
      \e[32m      0  B\e[39m #{testpath}/empty.txt
      \e[32m      2  B\e[39m #{testpath}/file.txt
      \e[32m      2  B\e[39m total
    EOS

    assert_equal expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end
