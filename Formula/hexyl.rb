class Hexyl < Formula
  desc "Command-line hex viewer"
  homepage "https://github.com/sharkdp/hexyl"
  url "https://github.com/sharkdp/hexyl/archive/v0.6.0.tar.gz"
  sha256 "5031b20c13b3ccb27abbf119b54609cef16c4152aca2823ee5c53cd5f434b97e"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7fe7b6f9430c7c6ffe0645ba7c5c921791723538272e102f82d3c69f62c4c01" => :catalina
    sha256 "b35036056ad68140fae0a7e0bed52112bee652edea69039527d4f2b0444680cb" => :mojave
    sha256 "e425d90bb0892027917cd36b34b78c08faa5fb4d82ade2eecf1df53181d76ed9" => :high_sierra
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
