class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/v0.4.4.tar.gz"
  sha256 "e71b29af433f5701483827620866fd6302999d08ddb559578261951da15601cc"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_monterey: "9b33aacfbe8406fb9c2a4e97f868d52f3577ebda0a93202eb5680a13a919feee"
    sha256 cellar: :any, arm64_big_sur:  "21fa40a2a13ca118705d23f27eb0207b839f8329322f73e4040e851d2532c861"
    sha256 cellar: :any, monterey:       "7338218e4d696b98cebea5afa011a5d75fc1e08b0b1f5b3d04b6842b89140783"
    sha256 cellar: :any, big_sur:        "6fb58b69b81b5d58644bf399e32982d90a46ab514f9f12b413198d62c334c7d4"
    sha256 cellar: :any, catalina:       "c13586aeeede3850d670f0e7705f43bc4c458b811aef6e4931186f0ee098d3dd"
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
