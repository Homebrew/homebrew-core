class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/v0.4.8.tar.gz"
  sha256 "c5fc2a4133a888633ce132f41c3ec542788de41cd03848ac34e36cfb8bafcce0"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "6103256cade5723bcc04e76f498e4440d4ae43539f1c420269cb4ff242ecb6cf"
    sha256 cellar: :any, arm64_monterey: "2b0ce97529579c5124ddd1e84f211e580deac0f40131aa5ab2846d69a77d423e"
    sha256 cellar: :any, arm64_big_sur:  "fbb59a8f1de72c02abbf7d4ddd3f77847782cf007511c6a0ee99fa85efdfcb72"
    sha256 cellar: :any, monterey:       "1ed4dc681fca9a241681bfd81551c4160b617def4488766580ff61a4aebfbba3"
    sha256 cellar: :any, big_sur:        "81f6c6ecff3385a577ec1cfbb6db119f734305269b8da9e214d130adf3630fa5"
    sha256 cellar: :any, catalina:       "d1cc6d4b8cd07c5e81c2bdac7dd89b7f09842344d3e0ad75791fab540c2adfa4"
  end

  depends_on "rust" => :build
  depends_on :macos
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/cargo-instruments instruments", 1
    assert_match output, "could not find `Cargo.toml` in `#{Dir.pwd}` or any parent directory"
  end
end
