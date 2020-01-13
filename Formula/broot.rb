class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.11.8.tar.gz"
  sha256 "e4cde6b6e8096337609144458b0777580241c2eee7700521802ecc8dd01130c6"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2075921d0a004c4a31ad24c42c9bf47c3c7de6dce024487fc1bbe430c59fe300" => :catalina
    sha256 "8c6d8e6e2165f049561d6dde55309d5b9ab0af39b18fb5c3ea0498b0df3113df" => :mojave
    sha256 "8df40bbf9ba3376d28589d610f25d18b25b05c443e0ee4861a7bb5f0399beb6f" => :high_sierra
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
