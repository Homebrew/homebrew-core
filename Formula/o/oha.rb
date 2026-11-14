class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "cd869a518c11252b4aaf2c12dc0c64527df2b69bc8f55b104139814912e67817"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ba96c188ec0840ebcf0792664e3d4b83700e661ba05c9d876c831b9d5309b0b8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a644297f3e813ab4974f38282ed0104590df190217f696661201a4701ed67cc5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1d2c4299f5098bf755201cd92ad1ac01b45bb9df25d36196150925acde4a107"
    sha256 cellar: :any,                 arm64_linux:       "3823f546041e48409e602513759eca910a7b89e876fd8b724104775e7a208606"
    sha256 cellar: :any,                 x86_64_linux:      "48cc6ef50f18b6b9f72737baa95a6b851e60d4fd66efab5fdf2542fe49c64b1a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite"

  on_linux do
    depends_on "openssl@4" # Uses Secure Transport on macOS
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    system "cargo", "install", "--no-default-features", *std_cargo_args(features: "native-tls")
  end

  test do
    output = "[200] 1 responses"
    assert_match output.to_s, shell_output("#{bin}/oha -n 1 -c 1 --no-tui https://www.google.com")

    assert_match version.to_s, shell_output("#{bin}/oha --version")
  end
end
