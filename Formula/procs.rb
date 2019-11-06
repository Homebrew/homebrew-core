class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.8.13.tar.gz"
  sha256 "4965628433c84abc01dc2974d4ae7e3f5710a11cbdfa8bb680a9a5d92d3e26ac"

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
