class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/refs/tags/v0.4.17.tar.gz"
  sha256 "51b9bb614642e5de30a8757de8bad988d63e2064c7eb5fa5a9fadadc22f35c06"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "abe5a19dc7b3551007122f352de254d4ce544dc2dba35bb6efd2a6e6051325bd"
    sha256 cellar: :any, arm64_sequoia: "6aa01e9cffc3f4f6c0fa611bbd58f69b4732e09a24a075388e8834242f935c05"
    sha256 cellar: :any, arm64_sonoma:  "9f110ad87270e265ab8fd9590af3e28429a2b76e007b43808381e1b5175a0af1"
    sha256 cellar: :any, sonoma:        "9e719583cf14cd5633e929007380abc8601e23d957ccd2022bfe8ba71ddf05d1"
  end

  depends_on "rust" => :build
  depends_on :macos
  depends_on "openssl@4"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cargo-instruments instruments --template sys 2>&1", 1)
    assert_match "could not find `Cargo.toml` in `#{Dir.pwd}` or any parent directory", output
  end
end
