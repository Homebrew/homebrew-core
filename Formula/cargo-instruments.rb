class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/v0.4.3.tar.gz"
  sha256 "f78146e82a6a1cf40d2c7d6f84652b2671f7c771ebe4ebdd9a798380c1e9c39c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4337fa71363264075999d4089113ff7fa3920d6a46ddede5505ed73cd66ae188"
    sha256 cellar: :any, big_sur:       "3185c0685f90123a76d4e1d85c44c537f2c6088fdfd467052e225d15bdaf29a5"
    sha256 cellar: :any, catalina:      "501cf5d9b290167e043f29e5464e1bd8ea49d5b28a591603370e4b47678e1a38"
    sha256 cellar: :any, mojave:        "83f9f2294675328bb4778d55af84e638b07d5620bece3f60cea388c8a484baec"
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
