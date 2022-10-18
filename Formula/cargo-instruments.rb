class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/v0.4.7.tar.gz"
  sha256 "05827aae15603ab8a3538a5c9df5d3571f8d28d9b5d52c50728fbc5b6f6bbfd6"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_monterey: "f360d5be9cb18c08a68e118a19dc619577d48f6c3650839f680b0b9850be417e"
    sha256 cellar: :any, arm64_big_sur:  "e13450358ebdadfe4a0b0174553f2a9c26ba41924141de44ffc4d63ac205ca34"
    sha256 cellar: :any, monterey:       "f4dff9c7ff52d482761be62dfd5e9026cd993a7d2c743a6454e8dc5fdefd3abb"
    sha256 cellar: :any, big_sur:        "51a35e0f988b696885717f8fa85e6180c1d91af087ae9ab0b9f4cebe0caa5eb4"
    sha256 cellar: :any, catalina:       "f854537b670e7e3f9fcc759bae716fa45085121d10f9f5dac3bd92d35e97f706"
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
