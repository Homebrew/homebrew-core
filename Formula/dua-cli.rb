class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.12.2.tar.gz"
  sha256 "87fded154a27780ad44b1833879968eea17844e469e6f499120a0243147540ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c8b5a46daec616a4308022def364b494b80cf08247d733eb6a431a22601b7801"
    sha256 cellar: :any_skip_relocation, big_sur:       "6e2c05fb930058d127105673f7379683ad50583d01b08e1e2cc9df252e3d6f2e"
    sha256 cellar: :any_skip_relocation, catalina:      "49c039c3cb01c456420afa8e69e03b23d59278fa1d9b1ad6984d209a3dba4256"
    sha256 cellar: :any_skip_relocation, mojave:        "3621a2b01bfdf24f82c0189d8db4d4c7952e5fec3a1a47aeabab1b98276ed5a7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    # The "-EOS" is needed instead of "~EOS" in order to keep
    # the expected indentation at the start of each line.
    expected = <<-EOS
      0  B #{testpath}/empty.txt
      2  B #{testpath}/file.txt
      2  B total
    EOS

    assert_equal expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end
