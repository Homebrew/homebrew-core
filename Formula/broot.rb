class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.13.1.tar.gz"
  sha256 "594130c1e985379ce60885aab1b961d2326d0e5b34816d1c3590cf5837493742"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "62bfe1e7e688633f6caba3ae146935539445691d81fe36bacd2edeed33ca1f4f" => :catalina
    sha256 "d89134eaf0dedfddb05fc37c360f86931d8fa380f4cd5cee9a6648b440707c21" => :mojave
    sha256 "f0c29f3bdf1abffd219ba0c7bb7e228703b74e5a04f5202cb4dc3044364cf2bf" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

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
