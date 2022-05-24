class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.17.5.tar.gz"
  sha256 "805a911300bbb5234c25f607b25444988a97c260c03c02932844aeee0ba108e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1b6edc596cd0a2e594aca9cf83bc02116bb2f2c3ff3b061cc14a65e27b51e08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af7243328afc93f8152ffd0ad59eeb7a9be5a20a72d7f64784a7f6e8369941af"
    sha256 cellar: :any_skip_relocation, monterey:       "2be85ef50c0d59a700d9c75691b832d388603486fec442025c56dba6c0a82d70"
    sha256 cellar: :any_skip_relocation, big_sur:        "918a0a4b462b32b109dc1d346c69c13e7d6d86aab67ac576b36063afb445d606"
    sha256 cellar: :any_skip_relocation, catalina:       "93742651935ebf0fd8fd11b9b7df6c8dd73c228ce02cd03d376c34303fedba59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3aff18890ef773bd817bb05277c237e175fd626f1dc6169383f3c97d54e2034"
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
