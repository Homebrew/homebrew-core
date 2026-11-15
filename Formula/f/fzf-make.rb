class FzfMake < Formula
  desc "Fuzzy finder with preview window for various command runners including make"
  homepage "https://github.com/kyu08/fzf-make"
  url "https://github.com/kyu08/fzf-make/archive/refs/tags/v0.76.0.tar.gz"
  sha256 "9183f49fe2026477288630a06b50a899a00d5a2786d45e2d4860e9f3e3ac79d4"
  license "MIT"
  head "https://github.com/kyu08/fzf-make.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "486a79258b3ea2101f97a85d83c0ad94cd6f2954cc08c42047ebfa619593049d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "60be83d2587df54ee4818faa81d39e326d623b1739345e7898ee3d842250970b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9204faf108252e981975485d106247457411aca046baccaf1d9267976f56078a"
    sha256 cellar: :any,                 arm64_linux:       "8479bb10fb8647a9c4b79d76f59c08a797d026ed93ec41897f20615f647061ba"
    sha256 cellar: :any,                 x86_64_linux:      "1b57626bea4c085981aaf02c9162378dc8173c846f698011a4ac7556cd5ab778"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
