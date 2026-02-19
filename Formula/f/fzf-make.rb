class FzfMake < Formula
  desc "Fuzzy finder with preview window for various command runners including make"
  homepage "https://github.com/kyu08/fzf-make"
  url "https://github.com/kyu08/fzf-make/archive/refs/tags/v0.67.0.tar.gz"
  sha256 "c545efe9155aea1d01966a455a3478a1cdd4348701e06fe8be2c2bae545ebf68"
  license "MIT"
  head "https://github.com/kyu08/fzf-make.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a382a32a1f95ded17f8bc120c9c4609103aa6927d51097f01abfe639b6efaa85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20a815ebe812643b6c9530e5385c17543656e841a2bf4bee1ef811408c274bd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d6438ea11020ae65f8a90b5815a8f6a08707d5a43af003895c536ad0e021845"
    sha256 cellar: :any_skip_relocation, sonoma:        "839942db45ac44308970bafe34cf99391b7227f1afa167cc8bc7b3f0c32e23a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de118f89a8ef64e3ccac6c14658416f31f0cfbc02240d35c2de7ace924d1c57c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e398ac0827b41f2847baaa4910e813264a8444346869b6f119f523924672a8b"
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
