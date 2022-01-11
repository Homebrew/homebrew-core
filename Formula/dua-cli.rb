class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "02de8d80347405a876867901bd16539b7d7ceac3095cabcbf9abae3d7da1f357"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4b7fb180550801cb5fffee2284882b2e7fcd905ee39c785e62f89d38f76403a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f4774e57003370135aa2b8f7009af6d35dd594028f64e3ff831e5ce82984c95"
    sha256 cellar: :any_skip_relocation, monterey:       "607ecc69f99b501135e682ed99e54efd784f2a579040bc79b0fb342bcecbe180"
    sha256 cellar: :any_skip_relocation, big_sur:        "42ed8e26b7cf67170d8a008d41f0eba7394b968a49a4e155d1d4bea09df0aa2a"
    sha256 cellar: :any_skip_relocation, catalina:       "a67612057ffd7d29a8d7668871e1ec3c212a5a4e3883cabf176cc33520810ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f13632a9ccb0bf3146d62d32f8a8df4d53613dd8d87e3813b398d6151bd35d76"
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
