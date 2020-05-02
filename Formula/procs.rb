class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.10.1.tar.gz"
  sha256 "e5012c799c1221d17a9335e242aad1be7a466ecd67185746108c2b6dce87000a"

  bottle do
    cellar :any_skip_relocation
    sha256 "33a58c80c325abab5bc3d129c295120c7d6fab414b667cb59d6e81a35e5fc927" => :catalina
    sha256 "517b1e83bdb56497733bc47048990c54c04abd20961aff191f98c462d34b2b41" => :mojave
    sha256 "aecaba18d6e90ea4d1422ba1424846bf36d246bc862486cceeffa43f8acc3be3" => :high_sierra
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
