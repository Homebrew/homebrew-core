class Diskonaut < Formula
  desc "Terminal visual disk space navigator"
  homepage "https://github.com/imsnif/diskonaut"
  url "https://github.com/imsnif/diskonaut/archive/0.9.0.tar.gz"
  sha256 "93564a195a62796f95eacc154ad10df8f1050c8a0b2e2e22a0612228c930c1f5"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/diskonaut", 2
    assert_match output, "Error:\ Failed\ to\ get\ stdout:\ are\ you\ trying\ to\ pipe\ 'diskonaut'\?\n"
  end
end
