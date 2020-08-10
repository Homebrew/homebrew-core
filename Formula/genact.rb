class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/v0.9.0.tar.gz"
  sha256 "f606db6efb5d471df8e52b7cb17aec991936a6dcc1afaa2659aeca9ee1774d44"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "550cbb0ca15284dd7b6bbf4e006b80972a2ba3e1aadff66624b1bcbce9f70f39" => :catalina
    sha256 "403a5768a7198c6d317a8170e9eca2937ca3e956c418b041840f2f30f811ffc0" => :mojave
    sha256 "0f53228b7e1bc47bab7b596067b67e3670649749a5192d3435e6381069d6d1bd" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match /Available modules:/, shell_output("#{bin}/genact --list-modules")
  end
end
