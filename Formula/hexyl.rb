class Hexyl < Formula
  desc "Command-line hex viewer"
  homepage "https://github.com/sharkdp/hexyl"
  url "https://github.com/sharkdp/hexyl/archive/v0.6.0.tar.gz"
  sha256 "5031b20c13b3ccb27abbf119b54609cef16c4152aca2823ee5c53cd5f434b97e"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ea951a75e72e97075b3d4db45edbfc6cbb27b67c4655fcd1483ce6ad2c4165d" => :mojave
    sha256 "52d0981ef2edc478f11e8c66a959f2868c0ee7e20a3178064ec289dfaa71e397" => :high_sierra
    sha256 "688108b44f0fb529f1085a1e7416d445b6b6c12885a9a941727c950233f8b6eb" => :sierra
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
