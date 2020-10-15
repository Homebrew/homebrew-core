class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/v0.3.2.tar.gz"
  sha256 "ef33b74bf7a72de1c12c13fa596e2ca8ca2beb1ecdad6d9108511dad576a02a9"
  license "MIT"

  bottle do
    cellar :any
    sha256 "99f2afe2d147cc1ee0c5d2cb79cbc66046487ae3175b3b2c1d4ebaf7e745c124" => :catalina
    sha256 "cffdd706a6e683713c7dc00c40d097a83686b1e0192e23a080d60544d424658b" => :mojave
    sha256 "4e4d3078d79038132aaac1e1277efa5d3b7e1fe2162af47e5a9857ec10149dc4" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/cargo-instruments instruments", 1
    assert_match output, "could not find `Cargo.toml` in `#{Dir.pwd}` or any parent directory"
  end
end
