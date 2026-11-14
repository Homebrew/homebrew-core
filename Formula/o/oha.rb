class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "cd869a518c11252b4aaf2c12dc0c64527df2b69bc8f55b104139814912e67817"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d4a13fba7f72795e7a2ce5817558ffef55944a1a488fc8c0b72acc799d394a21"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e4956395053d93642c680e7a6bfa57893720a8988c9460f036c09e4d3086804b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "77c55016ffcde619acb6c58da9cd03d33adf96c93841b867b178c482265fe3d3"
    sha256 cellar: :any,                 arm64_linux:       "fbb2e8f15a5bdfd671feb02204adf23a2cd54240eddfb3b5cd8b98651096a2c4"
    sha256 cellar: :any,                 x86_64_linux:      "9f39b0b91ef34bdba5132bdf31c6ffa76341225085e96b91a259cb0090f26eb9"
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
