class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.1.10.tar.gz"
  sha256 "f40e63cf8bcf7d70a42d528696fe0355ff5a4a80cfd654593dabdd866613bc60"
  license "MIT"
  revision 1
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "551e89072e0aec54f96f430f205f1006354f233309328d871e147d90a06b1166" => :big_sur
    sha256 "ca283a7fb3775353c6b8d16d4b70c38141318904eb517ab7a401b04c665c7d3c" => :arm64_big_sur
    sha256 "a1ee259db5320844c395dd0eef52650b52c2bca2a932a98e05eef909b473133a" => :catalina
    sha256 "d02f559154d0e8cb45b888fd2a5d6325c5bb54e29abf40dc03c1f5c6b40266fd" => :mojave
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
