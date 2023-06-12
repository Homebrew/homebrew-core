class Lurk < Formula
  desc "Pretty (simple) alternative to strace"
  homepage "https://github.com/JakWai01/lurk"
  url "https://github.com/JakWai01/lurk/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "ef79a52c5c69bd2e765a3e000895d53fb66271d727857f12f5d749e600129227"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/JakWai01/lurk.git", branch: "main"

  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    out = shell_output("#{bin}/lurk --expr trace=\\!/o ls")
    assert_match "execve(\"\", \"\", \"\") = 0", out
  end
end
