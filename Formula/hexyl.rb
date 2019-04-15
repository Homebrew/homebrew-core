class Hexyl < Formula
  desc "Command-line hex viewer"
  homepage "https://github.com/sharkdp/hexyl"
  url "https://github.com/sharkdp/hexyl/archive/v0.5.0.tar.gz"
  sha256 "6241a4cf3e3ec2f32164539ef158c84ad29c53511cd1e3c0148776b8ce5234d4"

  bottle do
    cellar :any_skip_relocation
    sha256 "4662a02fa6c3e47e9d1376a177c74c7127dc16a7ee6939538d01ef425b2cbf3f" => :mojave
    sha256 "652e4e4a0a661d3dd97aaab96a4d33ffc8096a58773621e612e80f22a9df32f7" => :high_sierra
    sha256 "2b52aef13a792296811d7ec74719b56f0aec3e3302b19d48f82731ab952aeda4" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/hexyl -n 100 #{pdf}")
    assert_match "00000000", output
  end
end
