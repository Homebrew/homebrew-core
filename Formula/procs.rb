class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.8.6.tar.gz"
  sha256 "ee045e780cfd76fdb49a1011c46a7a222d6e6af9375600554f94eafb3713812d"

  bottle do
    cellar :any_skip_relocation
    sha256 "97718baac6988632fa3d389c7ad04b946e829b2e5e4fa9c150a8cf73f5e8256e" => :mojave
    sha256 "1fb78110c894a930edd77c2d00f9fd3f7398359196184791262884eb8e610b40" => :high_sierra
    sha256 "ea0d06dce2a5182dd6c436ab382c6a96fec4f12607bb2ae081c478b2723f7792" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
