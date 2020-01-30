class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.9.4.tar.gz"
  sha256 "d590df54201e89691a110cc0117c839add51f43681fa4f1a0e386f17203e9c60"

  bottle do
    cellar :any_skip_relocation
    sha256 "7041b535669d9f2943c675f8d5de52f86c6299c2f76d7db79d234440486b7d85" => :catalina
    sha256 "e0455a7201a8574ca40ed1b0e2ea69993fd2d04c60f93aa861a793b9d236cdba" => :mojave
    sha256 "3fd25abd1bf55cce753f8010f11fb534de226e2cf87a9782d48a783103f0fd7e" => :high_sierra
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
