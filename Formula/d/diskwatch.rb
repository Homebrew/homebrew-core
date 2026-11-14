class Diskwatch < Formula
  desc "Cross-platform disk diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/diskwatch"
  url "https://github.com/matthart1983/diskwatch/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "7990caf4e1279bf853d4e0a8e630dae6826c4282d9d9c598fb19c10f99a42877"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "05b1de8b9552f8c9ffe9803286d34d4d6bb4b17fe79f07f4bb8201b9cf942f65"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "854e36d1f51043e94ad29117525b1e3564e85922a51ce94392f40c5d15e22713"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7a8c4a65becea4e09eebe72719137d1930cf49fbb20572b5331d8cd915d0da57"
    sha256 cellar: :any,                 arm64_linux:       "33a3e33c0a8fedad08a3fa621e5406493172503fbe773954694ea4f087de00e1"
    sha256 cellar: :any,                 x86_64_linux:      "4403b3a1c748cab7892cd0fe71c4ed67bce31b523fe99683a4c438d6547ec745"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Devices", shell_output("#{bin}/diskwatch --diag")
  end
end
