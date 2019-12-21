class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.11.7.tar.gz"
  sha256 "3698beeb8e8b0f586dabba666c58f64503b7de470f3ebe1fd769d86a8cd73372"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6fa0d431eb939baf3260c436c37a273e68fc0ca26ae3a320f6d5df84171d50b" => :catalina
    sha256 "86eea9278e02f9888e1bc5c80342579620a696cc50d1aebe54416b1f98cc0b94" => :mojave
    sha256 "242b5c4c68e6db4ec8624f80b610607f69f17d729ec2b990f8af7caa1e86e6b1" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/broot --version")

    assert_match "BFS", shell_output("#{bin}/broot --help 2>&1")

    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/broot --cmd :pt --no-style --out #{testpath}/output.txt #{testpath}/root
      send "Y\r"
      expect {
        timeout { exit 1 }
        eof
      }
    EOS

    assert_match "New Configuration file written in", shell_output("expect -f test.exp 2>&1")
  end
end
