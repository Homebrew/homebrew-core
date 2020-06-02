class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.14.2.tar.gz"
  sha256 "b6cd74c726a33168b674ff302a9404935ff71c7152d9a31cd7c040247a353348"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed145e362a8bc0be3944de2be2b8e5dee00cbc2471a3bb6921a7b4418c453d1d" => :catalina
    sha256 "d9921b853775260534432bd02778c92805e10329151dd62d35f8f1b7f09555e5" => :mojave
    sha256 "f65c4bfc4f256c83c988a789f2046d8999e07356e8da0f7e7f09dd4501ae9fe5" => :high_sierra
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
