class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/refs/tags/v0.4.12.tar.gz"
  sha256 "0ecc0440dd36a40aed1cfc5222c93ec432f084b0ffa569ba9f48439c4bf41211"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a9230942af96929b1d806e7e6682650964ebe8d8799857ee46849dc3ea7fe20f"
    sha256 cellar: :any, arm64_sequoia: "f69b6cb11b0a0e38d7818f503c5288c84db02dea3191f068f5bef43381385116"
    sha256 cellar: :any, arm64_sonoma:  "fff1288a25c52e3a201e9bce0bc4556b26567d07ba83fa2bbf7fa89bfc23882c"
    sha256 cellar: :any, arm64_ventura: "cd3cc44b10b674703ac6a1817d5bf3f4dd507e43634dc4362f2035b0dd6a64fe"
    sha256 cellar: :any, sonoma:        "dc5005ed3ccfe1d4cee8631aae4600830633f29e39d7c88f5de7d56bbc65ae37"
    sha256 cellar: :any, ventura:       "04595ff1b1e2f49409c15dd038dbe436608954a58be356425106466c6c6c5258"
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
