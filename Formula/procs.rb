class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.9.12.tar.gz"
  sha256 "ed3ddb652baa3633b2990ace1082a734d697b4882f3d7ddc75625f9cefa6a99e"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ead3c4ba2f6aec92f1921a063ff8bf63d372e1c10a6e013a279692b8bd4ae50" => :catalina
    sha256 "37a87905f51f7d537d36e9d973ecc4b25a730d800d03052a54adc2ac6b0fead6" => :mojave
    sha256 "5c3be01fe1c00eb1598b547fc122a4ce9a0c70b6ccec17c3d1f3725be6cd9828" => :high_sierra
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
