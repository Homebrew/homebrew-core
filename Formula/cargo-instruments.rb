class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/v0.4.5.tar.gz"
  sha256 "aa7539badcca7ede2973face64f0daacfa8c76fac511d21397b9b6837c138cda"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_monterey: "dc4ffd0e2079973e8c8e592f2d671a2828d9d82d5a09c11074598e66e45e3246"
    sha256 cellar: :any, arm64_big_sur:  "6e5cb9212ab83ee6fb85aace2a91f6caffd5865e5c70977da5ffef95bc2a4d24"
    sha256 cellar: :any, monterey:       "fa97b4eecd62a0aad7a3776095d4aef727821f0245c788b6a57b87aeb77dfd58"
    sha256 cellar: :any, big_sur:        "a5ab4d076aceeed2224592861d760cf071217d722adbcae902cc78a7720e7355"
    sha256 cellar: :any, catalina:       "8bac26a645dbbda1fa1467a803609bad0369e64e5be8c1c854a87919ebf52bcf"
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
