class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.2.1.tar.gz"
  sha256 "5be09d67bea864bbb2d1ce50e854c17490bbf42e2544a987a1c91b9ddbf75f41"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "20787a01d42b08bc889ef04e1bf6a9d6231c10626707b18a0e59e82d723e8b9b"
    sha256 cellar: :any_skip_relocation, big_sur:       "17706edbbc21cea61e4be2cf94bb71487945373de242eb5fadd4219983e80445"
    sha256 cellar: :any_skip_relocation, catalina:      "2d78d046da5e2c428f6fb065dd643024786d342b4edf20bef2e3639da625e402"
    sha256 cellar: :any_skip_relocation, mojave:        "433a5502b0e0e2bd331a098866033e571feb08c7d9d63da4f0706865eade2c50"
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
