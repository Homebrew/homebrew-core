class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.18.3.tar.gz"
  sha256 "e6f0c452d06f8e3e3c6350dca16028af24272c00a14d506b47cd5e65402fea49"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "43c695510593917cac7b9ee853662687ce0f5ebb180688951c34bf32bc7e3eb4" => :catalina
    sha256 "e3230483f513dbd6cd6500e0b34b896280e62d3eb8d4453eab59cb36cacca0f1" => :mojave
    sha256 "be5febb457ecf7c49a9060fd17e02d517c271eca9e9b150476ceda04b60b5450" => :high_sierra
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
