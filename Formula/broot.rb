class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.2.7.tar.gz"
  sha256 "7e592f79e5fd6766bcaa67e6635f2fc2f7ad08dfa9410c6713f7e06609856812"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cdc4ab6f47d1a2f680673c6afdaaf269d65849a3c3f823e30507d556e6a277f7"
    sha256 cellar: :any_skip_relocation, big_sur:       "60adfc255caa87f430aee17a5335aa59e2c6c9251a35b5912f70d79aab0bd81b"
    sha256 cellar: :any_skip_relocation, catalina:      "f1f34e4d921cc5d4ff03f29b5e53cec665b53bf6e4fe7ab53e2989c8f2a4510c"
    sha256 cellar: :any_skip_relocation, mojave:        "86e25c3dd3c22bbe070bdf73cf285c555f1c2dc20506b31a40245782c3f41c97"
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
