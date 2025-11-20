class Otree < Formula
  desc "Command-line tool to view objects (JSON/YAML/TOML) in TUI tree widget"
  homepage "https://github.com/fioncat/otree"
  url "https://github.com/fioncat/otree/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "047fa4a4575d703a1bf76625b49c9291c22b8877347b4ec722a365b4aca51f8b"
  license "MIT"
  head "https://github.com/fioncat/otree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15a3a2481c8406b3855a25e599d4ff1cabb0ce09678b1496dc639074b4dc6173"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0ec8e2b2e46cbe5efec838d376d031d9cf468ccda7bf8781e0c192ff35f1097"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3268b1b389c7a9a84ff664ace84c0f7ebef76785407673528284cf9c1c999f03"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca28e3db61400e5d3f839889c48c0e6768a5591caa7d5d2069094e8e8f41d5a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "255b84ba472af971f8b710a4aac10a0a96e888e2ecfbb93d1220443c6b345a99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa9719427f79d474632adeb96725e1c3572cc58f34ee1497b943c5a9f68dbd60"
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
