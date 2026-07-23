class FzfMake < Formula
  desc "Fuzzy finder with preview window for various command runners including make"
  homepage "https://github.com/kyu08/fzf-make"
  url "https://github.com/kyu08/fzf-make/archive/refs/tags/v0.70.0.tar.gz"
  sha256 "beff0a4094cdd146d5f7ea5821a1e2c1732b58243f2f5042dde31f6e8fd8e54e"
  license "MIT"
  head "https://github.com/kyu08/fzf-make.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3db504679498ed710ff8136c5d7d848b0eb8c92360c6ceb93bd8864719350825"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b9a968ce8df287aea36db76321f281e77c3e1d0f1b2fec55ea4dec430eab069"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fd2e0071a6c1cbbd8b64686a6deca7eed2b4b9f35d56c9b5c618cb2b35b5245"
    sha256 cellar: :any_skip_relocation, sonoma:        "02370e591aed97fcfcb451fe8a78eb7ffd2208b2ddcac2029ce0aaa20fede06d"
    sha256 cellar: :any,                 arm64_linux:   "b24be39c78778047671da994dd80a5b1a37e3e9c5fe5aedadecdf669d4db1d63"
    sha256 cellar: :any,                 x86_64_linux:  "3944a1653f550b798c9a3a6efc1b2c07b8ddf7986771ca61d04c334f42b53d39"
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
