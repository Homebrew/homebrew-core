class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/refs/tags/v0.4.10.tar.gz"
  sha256 "6d39f893d48527a01d4a30264307b11f339335af891e34e8060f33149f746b08"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "d61e8fb856a4e23a2893c9680e142d668aec7aa5a0574b6166372019fcae406b"
    sha256 cellar: :any, arm64_sonoma:   "63a5f00a93443875ed2df1d44472aa6546861e181aa179ed319c24a2b84d18f0"
    sha256 cellar: :any, arm64_ventura:  "dd745e70999ce8258115ac318710b22cc936ab4d92a10f16dceb56b110c21811"
    sha256 cellar: :any, arm64_monterey: "546ab7702caa2b2a7002a55fd5b21d5d5acfe504712cd89c89b5289437cfe548"
    sha256 cellar: :any, sonoma:         "df9ef1212bc5f2a91caa55b327e5ab5e3264604c7967c48d9de15774b02d4ca2"
    sha256 cellar: :any, ventura:        "e72738fcf1ce7ab2cad854b78f33e9ff0821be44720e1d49f64431a4ef836d23"
    sha256 cellar: :any, monterey:       "a2b9cdf6e0faa7272fb062e433dd37a87baae40341044d10cf6d77d902c03e02"
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
