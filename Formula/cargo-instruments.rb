class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/v0.4.3.tar.gz"
  sha256 "f78146e82a6a1cf40d2c7d6f84652b2671f7c771ebe4ebdd9a798380c1e9c39c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b67c1ae46a3f04740faeb1686e4f8efec7d38630016bef9ccc4648a88942ddbe"
    sha256 cellar: :any, big_sur:       "5f6ef51683a2cd8ed6fa66f749e0e3f7ea2e4abfe434c99df28eafbff9545eb2"
    sha256 cellar: :any, catalina:      "38d6e711b92d8b0a519ce2674efeea7f6622d6306dac91bf0066ac2fb63f9360"
    sha256 cellar: :any, mojave:        "03c10ff29c646e5231d924b8838eba1cd533ac261e1b73d5bf8eadea86e44c10"
  end

  depends_on "rust" => :build
  depends_on :macos
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/cargo-instruments instruments", 1
    assert_match output, "could not find `Cargo.toml` in `#{Dir.pwd}` or any parent directory"
  end
end
