class Otree < Formula
  desc "Command-line tool to view objects (JSON/YAML/TOML) in TUI tree widget"
  homepage "https://github.com/fioncat/otree"
  url "https://github.com/fioncat/otree/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "f71064cac1c7fc1047a119bdd2b630eac67008546d13b51b1ace1ab9b0314e02"
  license "MIT"
  head "https://github.com/fioncat/otree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7133f63fb0a0b7dccfdde99f6b46832ca8a9d15dd5c3a3a4aa4e6f49b0266c2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bec446f112db99edb483a6e8e6d116139401d5dd838f88985636be19781a9e23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37b9ac9b4424e26e8fe8db420414e500ffa33fa502d3ae165e87f1fdc1a7932e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a7210daf8444f20268668377bda516894f0ab79ddb438ead2db55424184c39a"
    sha256 cellar: :any_skip_relocation, ventura:       "68cea001f2492706961a6bb879d065dc6faf7aeb6a39a9d7154a8a54d8eae8d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28f8344d536731ccea43e576687313f44c7891b0ac612c5560d0b662a99875ff"
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
