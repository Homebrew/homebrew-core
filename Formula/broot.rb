class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v0.20.3.tar.gz"
  sha256 "2169646d9c5e8440fe778ffb6faacc40cd04643c86569e1b2f905e5241c33e1e"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5bace7b6742c062645ab06313fee65da33200104a2c12128cb2c2a3744a9a3d" => :catalina
    sha256 "72a2074ce071792898b27370cd8798b6824c7b66d12fc5ad7e975e94391d61da" => :mojave
    sha256 "5fc3f923e70df53434fb737ee18f40f080c2b1a974621b8ef9b1205b74b2e242" => :high_sierra
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
