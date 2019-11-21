class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/releases/download/v0.8.14/procs-v0.8.14-x86_64-mac.zip"
  sha256 "0c4fb6315a2c0e75735c0054f441996d803de4785d15fa402850c1ead35a1df7"

  bottle do
    cellar :any_skip_relocation
    sha256 "d972b07b96e612357319c319e57666b3906706c8dea370be2a58f70da043dd8c" => :catalina
    sha256 "6e5688d93e0b161aa983f653e07affc856cf27105f3019ee4b19ad913c8b5a7d" => :mojave
    sha256 "bf7abfb4cb5824280598fa0c4b1c9f03a4dc5a2421e69b62d2192b7d452d1aa2" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
