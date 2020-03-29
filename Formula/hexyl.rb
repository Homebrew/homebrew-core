class Hexyl < Formula
  desc "Command-line hex viewer"
  homepage "https://github.com/sharkdp/hexyl"
  url "https://github.com/sharkdp/hexyl/archive/v0.7.0.tar.gz"
  sha256 "92aa86fc2b482d2d7abf07565ea3587767a9beb9135a307aadeba61cc84f4b34"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1531718a22765e1af8df565b4a4dcde06f1bae3d9d0759249b2c964a4ec69a1" => :catalina
    sha256 "61a359905a259373422f68df900384320f072fd71d3b9d6c727f1d4aa2c7ab3f" => :mojave
    sha256 "670cef86e8c84b280c95a3219337349ee12456d284601149260532f7022af4b2" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/hexyl -n 100 #{pdf}")
    assert_match "00000000", output
  end
end
