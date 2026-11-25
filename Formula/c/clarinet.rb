class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://github.com/stx-labs/clarinet/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "6c1e07f908b059e574146f581a4fd0358ede768becfd5292602763acca7f924d"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "dad1b4619476fbbec7b77b32c5afc18a57be9165e7adc21172c9dae804b5b4f1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "20341951752338c8953db00411953a238743148cdc1248e578eee2b685d0270e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "321bf9cc0553e713ea0be269af210fe3f3d2669e6543771d3905656b08492ad9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c37a0725d24c6454f539f3344037115e4707c4edf5a75f98b84917a0f105bc1c"
    sha256 cellar: :any,                 arm64_linux:       "daa4dc4b490e8bd24fb3036a578bc4eac81da7e3eb723dab49d75ac063c3da5c"
    sha256 cellar: :any,                 x86_64_linux:      "b202862a34c2aa98c31fb7ed1d7f530fcfe1498259190328d410078add8fc609"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
