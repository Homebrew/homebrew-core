class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://github.com/heymaikol/network-doctor/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "c07b76f43623c528292cc6facbf51a8f512776d04ebd8aa80e45adb05c326527"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3453d56243ad0a971a7fbcbc6a321a406c5d4a5b2e2515645758fafdb01cafc8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3453d56243ad0a971a7fbcbc6a321a406c5d4a5b2e2515645758fafdb01cafc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3453d56243ad0a971a7fbcbc6a321a406c5d4a5b2e2515645758fafdb01cafc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "43e69cec067fadb86e0f1fdb15ce153cc118a02ffebc62bfedaf2ae59e08da83"
    sha256 cellar: :any,                 x86_64_linux:      "68ae2f94c20083282c9de4a54b7f91b18e423d1bf5639141a8ea97fcf603b9b2"
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
