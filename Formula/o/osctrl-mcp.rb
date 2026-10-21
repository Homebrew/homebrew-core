class OsctrlMcp < Formula
  desc "Fast and efficient osquery management"
  homepage "https://docs.osctrl.net/components/osctrl-mcp/"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "a7b8d6ab402890a8cc2a27a87246cc30e0e3e2c410eebfa0fe02807677def77d"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "42514db854e8fc70034b9cc6b6fae1e5314d84fcea3a909f1e9b12675721e0ff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1893766792df9cb2b2f127fb67366d1f52b3524eb3af6108283ccfa18f70e4de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cd3cb0d9a0ee4805907adcbbe0c21c4db916b36f336f1fb912544d63929962eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "38b708ef4c456407866383f5e5413e5fc397760b94b6648039451c45605b8b4a"
    sha256 cellar: :any,                 x86_64_linux:      "2d60653415c593d4d74d36fb9537f1dbd27e395d706194bb6aaa99fcbc9b03df"
  end

  depends_on "go" => :build

  deny_network_access! :build

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/mcp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-mcp --version")

    output = shell_output("#{bin}/osctrl-mcp --api-url aaa 2>&1", 1)
    assert_match "no API token", output
  end
end
