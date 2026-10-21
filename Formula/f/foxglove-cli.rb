class FoxgloveCli < Formula
  desc "Foxglove command-line tool"
  homepage "https://github.com/foxglove/foxglove-cli"
  url "https://github.com/foxglove/foxglove-cli/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "491085b6ee1e4213ab54e83154fda16a9571d1568cab81d5fa5b334bcb1428f2"
  license "MIT"
  head "https://github.com/foxglove/foxglove-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "687341376acde855f8a96ad578df91c5406f58e97a2e53707e3a8d639bea29b5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ac1f73eb6054c377719332eca1c9c588bf1f0dd069c9034d9122396356a7ae44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6583e30cef581361fb17f2364220cfce347d2048ae147fd1357d98e6d7e6663e"
    sha256 cellar: :any,                 arm64_linux:       "61e960f194d89e87bd2e50c1a4014d825d8bf3e0c47ac762a951bcd02dcccb4b"
    sha256 cellar: :any,                 x86_64_linux:      "885c9d1732b4f4aeeb3da2bacfac187ae44b44336d900d76f031e41318ac86b7"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    cd "rust" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    ENV["FOXGLOVE_VERSION"] = version.to_s
    cd "rust" do
      system "cargo", "install", *std_cargo_args
    end
    mv bin/"foxglove-rust", bin/"foxglove"
  end

  test do
    system bin/"foxglove", "auth", "configure-api-key", "--api-key", "foobar"
    expected = "Authenticated with API key"
    assert_match expected, shell_output("#{bin}/foxglove auth info")
    assert_match version.to_s, shell_output("#{bin}/foxglove version")
  end
end
