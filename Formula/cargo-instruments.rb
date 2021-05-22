class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/v0.4.1.tar.gz"
  sha256 "80eda3959bfe167d9df050df82fdeac0aec5606bb02384e2b4313a472bcb599e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "26e9d37606855755bb874719951d40235adb85f52632e224d4def9c542a9eec8"
    sha256 cellar: :any, big_sur:       "d520ba0e15e41a9ddb6101de2e60598bc40c52aa0480b28a1a88ae73a2753575"
    sha256 cellar: :any, catalina:      "db2eb02b67adf661492a63811a8c120f49958d0fbb01edd57a201fa848559f61"
    sha256 cellar: :any, mojave:        "20eb189ecca49ce5a0d0e81e0e66793218d686ac93e40a4f9da513501c0d212c"
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
