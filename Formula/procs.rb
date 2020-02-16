class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.9.11.tar.gz"
  sha256 "f02efcd319f2793fbbb10abf68cfae5067a269adbc88e8812bfcbcfd66a20471"

  bottle do
    cellar :any_skip_relocation
    sha256 "f43cd5f17fa8d659188dff477d69c10a50479eca520c17cfe190a25fad5926ad" => :catalina
    sha256 "2ce05fdab15480591d1bbabf707cb55d296fdb3a20af677462766244b40685d0" => :mojave
    sha256 "a0ce443d5458aa0c12416f199103bb5d80768e71e14eff3e4189b6c01c5a245d" => :high_sierra
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
