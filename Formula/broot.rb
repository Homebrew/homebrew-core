class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.1.11.tar.gz"
  sha256 "6924aee9300c803dbff0a330f0bc787388bc0435124e40aa9d06594949c5d6c6"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d66400f0046fb1f9e312c3508e7ccfa6a372973ab87eeafcee2538beab859ad8" => :big_sur
    sha256 "fa488fd3954ed78781ee7fc0039452c1be0f9c4390cae73eaca2fc34e2e61485" => :arm64_big_sur
    sha256 "54f14cddf27c8e0dc8bb6ebededc2ba5ff01fac3fa92559cd7efac7de7e9fa78" => :catalina
    sha256 "409e89a8825388dbbe81e9c8429e059851b5adffcd86204bb75a0300b4695d46" => :mojave
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
