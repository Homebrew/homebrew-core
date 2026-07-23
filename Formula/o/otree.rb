class Otree < Formula
  desc "Command-line tool to view objects (JSON/YAML/TOML) in TUI tree widget"
  homepage "https://github.com/fioncat/otree"
  url "https://github.com/fioncat/otree/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "4614dc618c87782639606973d262f9b4b5fd58987e3510dab8ad6074d6a8cb69"
  license "MIT"
  head "https://github.com/fioncat/otree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "527d64d1e7e3eea3a0e85a8816372d7bc055afbc67f45095cbd9007fb0e9ae8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5085830e97e2319f506bdae3e9c488518d56a089c0a604abbb5064399117305b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7a4ad8f2446fb585d00440f7cad7721986b8f540f7957a1e5cc7c2c8b7ccef9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8209844ef8cbbb1536608d6f29555800d9c3d88aede0ee03d7c01b912b8043b2"
    sha256 cellar: :any,                 arm64_linux:   "8097a611bf9b81f6b35ba0ab54ac6bc7a740552c87840e4d51c8eb1f143b5b2f"
    sha256 cellar: :any,                 x86_64_linux:  "2d701c24628083419687853f150ffeaaa5101814465e80dd36b0b4a3c4f937ef"
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
