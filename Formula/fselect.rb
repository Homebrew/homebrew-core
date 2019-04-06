class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.6.2.tar.gz"
  sha256 "fa3088bc6622a5684850e62d5b2a746b5c251e88b52ec3327ad1e256eff0cc22"

  bottle do
    cellar :any_skip_relocation
    sha256 "5fb1e30948137b37ce39712b96a8d547c6a0aab048eae470059536a57cf6abc8" => :mojave
    sha256 "979315eb57ec9e90e15f56d6aa12c48f254c4be75c9ab6e7ebb6155926e0871e" => :high_sierra
    sha256 "e8bffe196efa50a615d26993f97ba73c36ad3bcce380b5debe52d664992e4ec4" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
