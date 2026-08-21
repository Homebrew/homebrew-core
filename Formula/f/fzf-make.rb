class FzfMake < Formula
  desc "Fuzzy finder with preview window for various command runners including make"
  homepage "https://github.com/kyu08/fzf-make"
  url "https://github.com/kyu08/fzf-make/archive/refs/tags/v0.73.0.tar.gz"
  sha256 "2593c94142b263d2894575919ffc4843a032cdab3f109e59853df5de5f342be4"
  license "MIT"
  head "https://github.com/kyu08/fzf-make.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7b7d3e26dc52240a5218e9c164839b161314ee4e111955261e5ad01717e312b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "464e72f4335afe4b9fbf142767d0d7cfb6949cb1cd9b280d615284d39d757331"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b87b7f121f80c8fe353af3273b41f829aae3cf694116f0593f75c633c86a433"
    sha256 cellar: :any_skip_relocation, sonoma:        "68c98a34fb01dcb208d5e618f7bdd9252436dfa04c2a39c191c1bb6800d322f2"
    sha256 cellar: :any,                 arm64_linux:   "5bb0d6e2ea013a5368558d075926f466d7cc522ac25ab2e1a8bb4c3dd105ef8b"
    sha256 cellar: :any,                 x86_64_linux:  "6450dcc0b7e963ed9d6cd6b40ae4a4b6d3860191e50453574460c97589fc06ac"
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
