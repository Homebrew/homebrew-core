class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.10.7.tar.gz"
  sha256 "bf0da9d47be2cf5ee005328bfe173ad2a577772340dc6dc53aded42c0d335c56"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "07824511a6b6607a3e955037072b4ecb745698ebfb28cfcb56b6c5ed767eff59" => :catalina
    sha256 "c1687109dfad6ba278a1275733f972726fc04fd6fef3d802751d1b1c75ef461f" => :mojave
    sha256 "5635cb43d94fc426400e1f781e6c8a93ff911730c942abf7e50b7de6700bbe1e" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
