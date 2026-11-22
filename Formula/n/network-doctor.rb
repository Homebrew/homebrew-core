class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://github.com/heymaikol/network-doctor/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "75bcabcf83939d522690f4ee8637507b1169ce5550ec356ac0b3501c2b7bce96"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "444ab17ec15fd941756e2bf95f249406f185ba048f659b576a1c9e6b33258949"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "444ab17ec15fd941756e2bf95f249406f185ba048f659b576a1c9e6b33258949"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "444ab17ec15fd941756e2bf95f249406f185ba048f659b576a1c9e6b33258949"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7bfed94d781adc48df4ac39987dbb111dea9a9bd57412d3a5a33a70420e15101"
    sha256 cellar: :any,                 x86_64_linux:      "e4cab7b9fd07e0ae477e7960c1819fac4ca6cb7c9ab41284a2836b2b12f62bfb"
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
