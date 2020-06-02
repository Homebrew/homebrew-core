class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.14.2.tar.gz"
  sha256 "b6cd74c726a33168b674ff302a9404935ff71c7152d9a31cd7c040247a353348"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "067790797e22cdcce792e115ededa0d6afc020a0d8b422bc819a8299260ee49b" => :catalina
    sha256 "27803073b82780c27ebb226356a65ed3efe80e8cb4b137b9ee474804b94a01ae" => :mojave
    sha256 "0e12275ff11f4326918b0c885b2cb01dbff5bc31facd2e67ae8d7e01bde09226" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
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
