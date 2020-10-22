class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.0.4.tar.gz"
  sha256 "dea81eb5e340864b042f3ee4416298aada7e1d8cd2856177d5c49e7576648487"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4073625c13c59143976ff805a88ce3e6fc295ea767d0644d3a108b250097af54" => :catalina
    sha256 "66404dd0399eac068e7d7b794ed57794474cbd31d6e01e62ffae6d61b58ec165" => :mojave
    sha256 "9a91c25c2a9a1e70f48e1c243bd00686e641cf8312524ee8d7f1f34f37cbf101" => :high_sierra
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
