class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.0.2.tar.gz"
  sha256 "3aa821ec47837a668b34d60bdaf4a166bc7ae836a8550f38440a5b944660fcee"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc2d71d6a4087bc6ed15e47937382d5d76043666a6d7fbe4c6f4846830846fdb" => :catalina
    sha256 "32c3c10920be5e64284cd3dbd8841269ae43a8bc50aecc01ba7d87c7f6cec1e3" => :mojave
    sha256 "3c47a533e79801345aa2c57ebb4b318c8a1c04e777a16a253e303a93f4152a82" => :high_sierra
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
