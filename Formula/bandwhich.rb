class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/0.16.0.tar.gz"
  sha256 "fcb3ccc68e4ee86657940e879f23d122b7d8857472587e6864007c02a3cc9aa4"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5d748211d1b21b8d7f15514d817f6693b3d196146a4a969d103e41be4e1546a" => :catalina
    sha256 "672e16c6fb86958d26ade135782d30d60e378b6caf48026e3ad6888996bf5f8e" => :mojave
    sha256 "bd2cec70b421902c3c2d5b5697fff2f8da6991e068d1d05cc87b108ae8e43eab" => :high_sierra
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
