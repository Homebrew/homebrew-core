class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.13.1.tar.gz"
  sha256 "594130c1e985379ce60885aab1b961d2326d0e5b34816d1c3590cf5837493742"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "43eeaf906a5648cc1ee554e019bb07784feb6372bcc9aa939c366be4c38a9c7c" => :catalina
    sha256 "6c92d76311ea4eceab85eab11596171f756cf276546bd4c37463dc786a7189eb" => :mojave
    sha256 "86cd281c8e26c5f74fbce9c519c38cf2f87042f47be3f9fe23b069fa3c04433d" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/broot --version")

    assert_match "BFS", shell_output("#{bin}/broot --help 2>&1")

    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/broot --cmd :pt --no-style --out #{testpath}/output.txt
      send "n\r"
      expect {
        timeout { exit 1 }
        eof
      }
    EOS

    assert_match "New Configuration file written in", shell_output("expect -f test.exp 2>&1")
  end
end
