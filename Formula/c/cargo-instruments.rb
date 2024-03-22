class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "e59715bb4bc87d93c2b779c04d9262d26418e58216acb93ef79145d8a99730a0"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "3e1e0ccdd9052bad2af13e4c55e37ceb9928d40aa219a1c931b52fb9e75af2a6"
    sha256 cellar: :any, arm64_ventura:  "a4b65f5dba54dd193db05e4df09abe03518ce93b2e3a74f13452c768637211bf"
    sha256 cellar: :any, arm64_monterey: "dd5739c8aa34699954f078ba04fb72bc854690af3dbd0b48159ca83b28dd8779"
    sha256 cellar: :any, sonoma:         "a9176be794c87cca16ba814b9daa649369e46c4725aef9edcf07937baf96fa50"
    sha256 cellar: :any, ventura:        "65df44fba5416006eb5c78204e245916b931f59d66679312e4ae7c4df2762216"
    sha256 cellar: :any, monterey:       "822736da673a0eb1f7c52f9cbbe5ee8a329e44f204464e2a709eb962b5a90246"
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
