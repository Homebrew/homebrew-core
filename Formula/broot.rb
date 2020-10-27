class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.0.4.tar.gz"
  sha256 "dea81eb5e340864b042f3ee4416298aada7e1d8cd2856177d5c49e7576648487"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "196af7306b14e3672f784e6fdaa4cb8efa447307bbb113a62f0e2887bcf02536" => :catalina
    sha256 "fd1ee6fdecf2654a58bb1396ede64c2276a8ffb98a4b4d5d24227e41ecbf5569" => :mojave
    sha256 "fc9fc599f1a592957208b39541a442525face74f5300a121a472cd1bea9caf1a" => :high_sierra
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
