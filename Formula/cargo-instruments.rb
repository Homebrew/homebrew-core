class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/v0.3.0.tar.gz"
  sha256 "aa511fa2c9c6cdd342c333a7e6d1eb37644c53d2f5c6667510a24c0268b3d659"

  bottle do
    cellar :any
    sha256 "6f6f7b4d9d88a5c348d951c3b3d892bc8590e2eca6a3e5da6acd029509864cfe" => :catalina
    sha256 "bddab3f8c96413ad04f2bfc000f8b3228837d10c70a61924efa21cd723d2153e" => :mojave
    sha256 "9e2ea11924cc755373b8ac2c0b110b67930552009c0430a6a1d47729235b1a65" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output "#{bin}/cargo-instruments instruments", 1
    assert_match output, "could not find `Cargo.toml` in `#{Dir.pwd}` or any parent directory"
  end
end
