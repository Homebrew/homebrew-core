class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.0.6.tar.gz"
  sha256 "f703b3ff3371ea4ac94a091acbfe74ab6cf55afee5ae72cc273583d388ed941f"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "423fd83b04200bd91ac0558c48bf34d543333ed0b19da76215ce77edaea34923" => :big_sur
    sha256 "e0e104254d8f4e6245ccec6c87552a3b3960c6c5f81db0253195bea168636658" => :catalina
    sha256 "e7af6b7a1cfaeefe827c486669f1ee6339c54e239423b06debe9d55bbd212104" => :mojave
    sha256 "18d1f77fa3178531237c063daddde839281c2eabcc007ccea0c13ec7bc948e6b" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--no-style", "--out", testpath/"output.txt", err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
