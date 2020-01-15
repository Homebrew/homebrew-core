class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.11.8.tar.gz"
  sha256 "e4cde6b6e8096337609144458b0777580241c2eee7700521802ecc8dd01130c6"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "31b3ce75ae211ce1fb3e5e7887e9f69a5e144eaa3622ac7265c05563204598b1" => :catalina
    sha256 "26d160ab0f3e62132d126e0da677ffccbb840b88e4cdcdf2f4f0fa53f9ffa37f" => :mojave
    sha256 "d7afe598c6942bf988482846720849e55ca31fd2e97e40e100c46929f9feae9c" => :high_sierra
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
