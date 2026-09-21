class FzfMake < Formula
  desc "Fuzzy finder with preview window for various command runners including make"
  homepage "https://github.com/kyu08/fzf-make"
  url "https://github.com/kyu08/fzf-make/archive/refs/tags/v0.74.0.tar.gz"
  sha256 "3297dcff19019ff4099bfd271cd8463109bdd590a2ba5213d65ca3cd1b5d9d33"
  license "MIT"
  head "https://github.com/kyu08/fzf-make.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "45df1b036ee274f83ce9e7432bc8cfeddeb544eba3f77c495eaae3f6f895d78e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2a73e68c330f84aae59b81f1b737f1ddd817d9da9672b78b6f323f38278ae76e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aab764eccefae41c0c89d7c7c743e8ad7f08c8a90ab7b4c7341395f9bf6592b3"
    sha256 cellar: :any,                 arm64_linux:       "4e8c16ae2bece76936090d76198a9f4a56660b94b7fb6a1064825168717f99f9"
    sha256 cellar: :any,                 x86_64_linux:      "e30677e65ab56e0edddcb33277caed2ff090a215d35586896d4034aeb60e341f"
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
      assert_match "make brew", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
