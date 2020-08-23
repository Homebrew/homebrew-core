class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/v0.4.1.tar.gz"
  sha256 "2a713a00aef8db3de98fe5a936e84fdf7fcebfa8211aee03a4c7754aa094d7d1"
  license "MIT"
  head "https://github.com/hatoo/oha.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "31e9544f9612b2211bd224d6112da755ed92af8051046f13c518d95e3778a1b3" => :catalina
    sha256 "087d14cbe0e3972365b71896a7e29a60f95c0a943fb65ee4969ea5e222be34da" => :mojave
    sha256 "aff27d4b0f0a25c45707ed170b2ff63a32a83a5a48efcb48fd498b924940ffd9" => :high_sierra
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
