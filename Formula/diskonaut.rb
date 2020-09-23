class Diskonaut < Formula
  desc "Terminal visual disk space navigator"
  homepage "https://github.com/imsnif/diskonaut"
  url "https://github.com/imsnif/diskonaut/archive/0.11.0.tar.gz"
  sha256 "355367dbc6119743d88bfffaa57ad4f308596165a57acc2694da1277c3025928"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c993c723fdd17729bede2135e93ecadc6563a683d9ccd8ca6198bfe5406f53e" => :catalina
    sha256 "9fe9ede4850047aa096a2d30991d5e54e65252ef35c125cde2e66f03a676145e" => :mojave
    sha256 "36ab6bc3c9605ede8830d31ae14b53f794c3ffdb56812cf2c052c20483ea5df0" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "ls | #{bin}/diskonaut", 2
    assert_match "Error: IO-error occurred", output

    assert_match "diskonaut #{version}", shell_output("#{bin}/diskonaut --version")
  end
end
