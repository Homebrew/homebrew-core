class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/v0.4.8.tar.gz"
  sha256 "c5fc2a4133a888633ce132f41c3ec542788de41cd03848ac34e36cfb8bafcce0"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "e53774bdc10813969f128afed67d151e2ea73e2da3642d90fceb5a2ce0ab2fb2"
    sha256 cellar: :any, arm64_monterey: "517f55d64777be77eabe09fcc2318486acac7d2d72ea05a251150d9e9508672f"
    sha256 cellar: :any, arm64_big_sur:  "ea43a6b13ee8bab547c14182fe8022b8f4f2cd9de9d10f68b69067cd57308ffc"
    sha256 cellar: :any, ventura:        "9a2a75de53ca739155bf9a38d0e7b611544f3c647641fe3569d3194cec9b0639"
    sha256 cellar: :any, monterey:       "739e75a78c51709fb30681eb383c7978bf813732ebac4006a91e79cd87c2bebf"
    sha256 cellar: :any, big_sur:        "34087ee37b15a2d460386633797f6b19562c87beefae8609c5d8ec766b1620bb"
    sha256 cellar: :any, catalina:       "8d957e40b0d946cfa58d041c63536a0fe205a9893b4e2122811dc7ee98596eb3"
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
