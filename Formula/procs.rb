class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.9.18.tar.gz"
  sha256 "b44db0b77c017afcbaeee917727abe3b82b3e479bdbc16111fe755dc0377c58d"

  bottle do
    cellar :any_skip_relocation
    sha256 "600b76535876939ed930a48f43fc9eaa8696bcaded5727e7505ddd07e5da852b" => :catalina
    sha256 "ab2c27ac99a974456b14b02b6d7410ae9c754fffa83995e5a318cdd5404e7691" => :mojave
    sha256 "327f984ef46ff7076e9705122bac4cad86ec60a73b794ba6c39aea9c2bc5a584" => :high_sierra
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
