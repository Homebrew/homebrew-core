class FzfMake < Formula
  desc "Fuzzy finder with preview window for various command runners including make"
  homepage "https://github.com/kyu08/fzf-make"
  url "https://github.com/kyu08/fzf-make/archive/refs/tags/v0.69.0.tar.gz"
  sha256 "b4eb620296363f3e4674d14a31f0ac5ec2a44e4b8c6c1ee024d0399c49e31a8b"
  license "MIT"
  head "https://github.com/kyu08/fzf-make.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1891dc04506f171d01cffcf6ff48c2f3444ba694bb38b5afbcf4f4f509cc54cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e70340965fbb33f19f7dc8de3d177a60ff5b4f8890f93712872879168236e62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a03af1545620f5361e5ad56bc7f51b1d318391d48f4b1ba8bfb4ac4c2ddb0a6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b661eadfc76d881f6d3ca59671845557a6250f97ac3df64652c262b65f9f6bb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d596bd5dc007c2dfd4f8f66b4600a0499b5f074e2affc9949d3ec724d1ef8b97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d455a312c0cfd90dbe6370d14d9d243ccfd494b233091305e77f1c90a6945bf"
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
