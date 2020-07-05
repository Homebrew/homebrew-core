class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.18.5.tar.gz"
  sha256 "ec63f8223dcf7039cc9921ee9cc4a5b3196abb8df2b25a9c3dad3307db662770"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "391e428c2763fbc8a8372a98adcc2c72c14159f3246342e1441d456053879b69" => :catalina
    sha256 "8770854b58d752343b2eec55ff7b0cb73df4d352797e5319867c5cb2cedbd574" => :mojave
    sha256 "df5feb9a6dc9f6c649046d8b67cf5b6c6b7fc963f02dbd443cd2e6f833b2dc60" => :high_sierra
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
