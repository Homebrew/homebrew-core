class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/refs/tags/v0.4.15.tar.gz"
  sha256 "0e3271b10d917b5b6d8c86689c04a7c7facfb4c9ed6aafebe34f72b42c01690a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b24f1b8b1c0b8438f5281f3c4651f68fb7a66ab15da73379da514ffa62754a9f"
    sha256 cellar: :any, arm64_sequoia: "37bb045d1ce6ebe87901932522dbef2ba0c837ea2331ceb73b725e6b3009cb01"
    sha256 cellar: :any, arm64_sonoma:  "13bc3989d90a6a09b2c7c0b77867138f4f32d5adf06b7adce40422e47f744c9c"
    sha256 cellar: :any, sonoma:        "e2428340b1b044eb596e9a6c278d2c669a7677cb2b0f42e01d33e53c312c5bd9"
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
