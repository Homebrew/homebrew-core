class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://github.com/heymaikol/network-doctor/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "75bcabcf83939d522690f4ee8637507b1169ce5550ec356ac0b3501c2b7bce96"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "ad9c3d996a7b44f27c8bdc74e62882dc88b9e584a31593b835d8d1e6b881b8dc"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0c7214adde5c2982053e3adfb4228bd349ec8e9412e3afdc47b77cdbd922d0b9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0c7214adde5c2982053e3adfb4228bd349ec8e9412e3afdc47b77cdbd922d0b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0c7214adde5c2982053e3adfb4228bd349ec8e9412e3afdc47b77cdbd922d0b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c453a16f9caded2ad8b5bee27ac01e2a9e22665cdbb3cde90b5e5818bb44cb02"
    sha256 cellar: :any,                 x86_64_linux:      "7538999691c23748e40ac6e2dabd65ede8d1af755dcfc5b9db8c44d5cfa5f59d"
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
