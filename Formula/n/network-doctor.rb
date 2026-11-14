class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://github.com/heymaikol/network-doctor/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "267ad906f11b759c3341487a5a294e8c1085b83a0566e483ea60556d45d22009"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "45fc7c2582e8d2f4c9432a61681f44ac63c4881fcc2fcc093570fc84b652fb7e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "45fc7c2582e8d2f4c9432a61681f44ac63c4881fcc2fcc093570fc84b652fb7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "45fc7c2582e8d2f4c9432a61681f44ac63c4881fcc2fcc093570fc84b652fb7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4985cf47bc45645e9785512845253d06266b04e721eadc97228d92613118ba6e"
    sha256 cellar: :any,                 x86_64_linux:      "8c0308fca7880d2bbf0127d528bd3aebb27e8ebf9f76314104546e2b312558e2"
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
