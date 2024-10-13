class Otree < Formula
  desc "Command-line tool to view objects (JSON/YAML/TOML) in TUI tree widget"
  homepage "https://github.com/fioncat/otree"
  url "https://github.com/fioncat/otree/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "58ff9da6ed8653787082771377d6a7e099b187651f3e288856a7eb1f58355c81"
  license "MIT"
  head "https://github.com/fioncat/otree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4a7c9a77e048fd48aafaf6cde49a86e7e590c2e3c9c06aab768cbe56d558906b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f4b04b2aae647bd6d76aa701fb9169daaccc83662c3f4b94698d380444dae9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9709bd34263c5a6dfb0d1cde0dbe30fb513a4776818e25ab699bb252e5806da9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49e6a2a79ae6a2bb8ddbaafbcf8289819d3e27b3632cf0362029186527b46091"
    sha256 cellar: :any_skip_relocation, sonoma:         "011c3bcce610e133634eba74da4db716c97a6e259c8bc697851554778fb7aaa3"
    sha256 cellar: :any_skip_relocation, ventura:        "1ee61f2347a0cf82b6c47456d4ab85bcfc6a2c6f7917f8af0bcd7021c098b64c"
    sha256 cellar: :any_skip_relocation, monterey:       "041038d7b1e7f796b590cbed781d2b9757be05c427307a5d2302bca795ec9c5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ca571bf420fc505f2665110ade42e35ee4a6e32c813e7f979a35f9d188c3425"
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
