class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.12.1.tar.gz"
  sha256 "e2036165dce4a8e77a2e6d1ec5c8f4c2bd63027734b1e660d3cf6685179f5846"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "94f495b23dc7dbf0012ee33efdfc40f3742ed6b74c9c6ab49452e21889cb753d" => :catalina
    sha256 "3d6929d1fa011ad6d0ea039941f7e43a3e5524a1d871f4c31e660c9a9e32d2bb" => :mojave
    sha256 "4ac5eacae4f75c830492431a8468d8f73312b8335092ac7b846f315c08d958b0" => :high_sierra
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
