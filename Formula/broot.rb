class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.17.0.tar.gz"
  sha256 "b970748f34536c73f97cd1351768f9067a9d954be885ab65146378e0b0f20089"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1522a472c8b783a56ad9c0222cb258a842860caf446b0d4d8c535f46d94a1548" => :catalina
    sha256 "4944847f1cda1bdd474294d77e6497360433c11182fc8489b104fe908cd19962" => :mojave
    sha256 "a0bd897457d96ad7b96f907538d61541778ed8541925789d586377f2687fa68f" => :high_sierra
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
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--no-style", "--out", testpath/"output.txt", :err => :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
