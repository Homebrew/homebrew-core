class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/v0.3.4.tar.gz"
  sha256 "d9549e7bf0fb31b506a2d838029650f624a352146d968e60d653bac10c5fd1da"
  license "MIT"

  bottle do
    cellar :any
    sha256 "f4ade004ec38321549c0bf97991e2287903a3060b81d44669892c5fc029b272c" => :big_sur
    sha256 "3219c8afc7d140af7303638fffd6b2fd0fb32bed6eb7c96397b226cf1253b075" => :catalina
    sha256 "e1d7580bd468085d12f052d988fa7b91076f18605d5a2f74f4d085d5ebd186f2" => :mojave
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
