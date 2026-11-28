class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://github.com/heymaikol/network-doctor/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "6f1307de31733389fd3968fdb3fc296e4f4cc75aa7f35d4c9806256d60d4636d"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "fc3fea1f4e7c7dfa1e4ad570e27a22cb9fd91515a80741263bbf056f59baaa98"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "95597ce4647f3fda84c5cf8cce0270c0bb761eb29ccac207577d527cc6301afc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "95597ce4647f3fda84c5cf8cce0270c0bb761eb29ccac207577d527cc6301afc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "95597ce4647f3fda84c5cf8cce0270c0bb761eb29ccac207577d527cc6301afc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cde1ed30f034cd8a2a1d1e07229291f48018994973ae49fba91f5d941d1dcdb0"
    sha256 cellar: :any,                 x86_64_linux:      "450f30c53edbcf6e586010f6fd0b070bce04f4f57ce5d7fe7f1d00b90c314c66"
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
