class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/0.16.0.tar.gz"
  sha256 "fcb3ccc68e4ee86657940e879f23d122b7d8857472587e6864007c02a3cc9aa4"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb83c727c5291d983c43865d1b6f6ce27c173ad883e24f1d9ff61909fe159580" => :catalina
    sha256 "e84c13bce1bf2e21052fbc23f8f77ffb18fa61840af4881895df8164e2bb1c09" => :mojave
    sha256 "247f4d7303f2053bbb920b260b39e017ab2cc8140862edfebcabdb5c2464c0e5" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/bandwhich --interface bandwhich", 2
    assert_match output, "Error: Cannot find interface bandwhich"
  end
end
