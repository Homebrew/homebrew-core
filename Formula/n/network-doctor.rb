class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://github.com/heymaikol/network-doctor/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "093a9393caff479ee6f0ef8f006dfb68b06bca3033fb00a56d9fa7e87cc64bb6"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "2086ff3d941cb7c32b0edae460f8f5c795fab66d16523b05519c2a4266dfafaa"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "51a6f51deed50d4150a197733f410ed4f22bdae3cf74287197485d038879406f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "51a6f51deed50d4150a197733f410ed4f22bdae3cf74287197485d038879406f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "51a6f51deed50d4150a197733f410ed4f22bdae3cf74287197485d038879406f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7ef5d6811c40412e6e28691dbf336e76ee473d0863afa20528e328c8f2b3dbc4"
    sha256 cellar: :any,                 x86_64_linux:      "151ca960bb1d2e7b5336ffee63c7e8d64392a35549f2f7f667418d735a8319db"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", output: bin/"netdoc")
  end

  test do
    output = JSON.parse shell_output("#{bin}/netdoc -json")
    assert_equal version.to_s, output["version"]
    assert_equal true, output["checks"].any? { |hash| hash["id"] == "iface" && hash["status"] == "PASS" }
  end
end
