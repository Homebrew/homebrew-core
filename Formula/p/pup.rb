class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v2.5.0/pup_2.5.0_source.tar.gz"
  sha256 "03a7a6579f367392d2eca4fb89babf94e25b0d5ed25989957078ad67e8176098"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a8b2a3b4b0e3dcfe7ad105707cf2c42b1c7e7e464c1d106aadbeab008a776ec7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0c851b286e025531d30de3cfd3e25b5657a4ce6e002fbc84bb318fbed1985016"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "33fa194a655b286a9b37049c408dc959db2e80d622aab02d2fca2cf142f16e61"
    sha256 cellar: :any,                 arm64_linux:       "f8deb8282f38abc619bf070ae1badacc153cba00a83474ab0fbb70438d59aeb7"
    sha256 cellar: :any,                 x86_64_linux:      "76ecfc9198aefdab349dd28222b2843d5600ab4456acab2c28955e58612500b7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end
