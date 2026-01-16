class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, yarn, just & task"
  homepage "https://github.com/kyu08/fzf-make"
  url "https://github.com/kyu08/fzf-make/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "a7d19fb09bf9b92a425269a2dd0bac1f1260e90e20bb777d795c6d411508b49f"
  license "MIT"
  head "https://github.com/kyu08/fzf-make.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9848de4ad3aa8dfb14b43c3f7f84fd80508863ed056a6e45ccc762c62b6bf2fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ecf1fc75f55ef610947b74b4d12af1a5d1cff0756c524e41be0c919ae35a597"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4368b82d3fc82a636b8b053b3d124a2280c34595ba9cd369d370c17970e1b33c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd04430fa9479e4309cafa4cc4b7f1caad0d5fd5de1a9a23990529c8feab446c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ddf1cc10c8f70d0bfd36f475904966036a891c8a72e49e97fb96fe8b2757292"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea1a3cb28d540059157a71affa2ceebcd1f292513e63a840d2397a39c62250e8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fzf-make -v")

    (testpath/"Makefile").write <<~MAKE
      brew:
        cc test.c -o test
    MAKE

    begin
      output_log = testpath/"output.log"
      if OS.mac?
        pid = spawn bin/"fzf-make", [:out, :err] => output_log.to_s
      else
        require "pty"
        r, _w, pid = PTY.spawn("#{bin}/fzf-make > #{output_log} 2>&1")
        r.winsize = [80, 130]
      end
      sleep 5
      sleep 5 if OS.mac? && Hardware::CPU.intel?
      assert_match "make brew", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
