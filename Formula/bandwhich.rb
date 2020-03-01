class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/0.12.0.tar.gz"
  sha256 "195693dccff3f5104376c2aa83340583440ac2c40c4f4289fe07b6948ca5d363"

  bottle do
    cellar :any_skip_relocation
    sha256 "3d7d1fabb376a16a9032c749c5c3b3706ef0d2564a49ed01d6997cbcf25aaa32" => :catalina
    sha256 "f39d40a9b21c26095a7765ea7f253fdfb941cff585be5b90523f56a0dfb9fb1a" => :mojave
    sha256 "f999a556ead0fde601d580c17b465bd68dd59cfd1a161e8cbe65031e1a3f7315" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output "#{bin}/bandwhich --interface bandwhich", 2
    assert_match output, "Error: Cannot find interface bandwhich"
  end
end
