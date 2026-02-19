class Otree < Formula
  desc "Command-line tool to view objects (JSON/YAML/TOML) in TUI tree widget"
  homepage "https://github.com/fioncat/otree"
  url "https://github.com/fioncat/otree/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "eba6aefe43b3f3b3412e7c3545d88018dc6cbe35bc0824f6f5eff91ac44d4fc7"
  license "MIT"
  head "https://github.com/fioncat/otree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fa13dacac20e5fda14a7187d3023cfd885723caf50c3b44935b5a7732263168"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa40b75134c6e01bf8410f0f8aaff334f1de9d3809b9a4f76a6a6f2959274bda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2667d07c8ed110b85e73d223e7b2531100fe2b84ff4251a3c243aebd65edf439"
    sha256 cellar: :any_skip_relocation, sonoma:        "e70446ee625cc18972884068a166d4676c93a1328958ae7b7bc4674802b37fd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe8869351c5f6ff6cc141a7bef25d10567e1a87003bfff67b565096fcbc78aa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "426595a8c11659739c2c053e5a348cd060577d5a2d02b5ebc70440eb491d7fa0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write <<~JSON
      {
        "string": "Hello, World!",
        "number": 12345,
        "float": 123.45
      }
    JSON
    require "pty"
    r, w, pid = PTY.spawn("#{bin}/otree example.json")
    r.winsize = [36, 120]
    sleep 1
    w.write "q"
    begin
      output = r.read
      assert_match "Hello, World!", output
      assert_match "12345", output
      assert_match "123.45", output
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end
