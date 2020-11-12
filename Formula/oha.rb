class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/v0.4.3.tar.gz"
  sha256 "99c5e15e6d624dde45efe8bf83383eacd7bcfed135c9e1e65b7fa72824e6cde0"
  license "MIT"
  head "https://github.com/hatoo/oha.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dfd91a6ef9485f316135860f80d3fe67253628a3241db13f5d1aa503cf85e082" => :catalina
    sha256 "67bbcd316ad4fc232bc4ec393047e00349cac0aaeea3321469ebb4f7c630994a" => :mojave
    sha256 "f76dca0c0f67b43555822ea45995dcb971be92833bd30bc2b29ef068b246c2b4" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
