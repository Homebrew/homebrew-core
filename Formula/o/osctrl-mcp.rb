class OsctrlMcp < Formula
  desc "Fast and efficient osquery management"
  homepage "https://docs.osctrl.net/components/osctrl-mcp/"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "2de1f3ba46cd9a82c0a40c9be7ad3cabccdda9fb16bd2d70c6ab113d21b145d8"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "63f92ae0ad1971d6b4cc01827bd19434bcbc438f5e2507ac9fb78bbce3359e8f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "499832313e223de91d1e2ee0fcc85248d78ac90b8d2eb09279c40013ad377d93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ac2e18fad911f20fcc90dd76a29f77352a225d9baa7aa17ae720db3d550a0aa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "fb0af9d485d310d761f83a01bcd77b900d95747dfc2bb9b34e3d6e57ccf7ec64"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ce73574f94fbc0039a4cfd92addf844d24f264ea333a2fa3c1f9d3cd06b2797a"
    sha256 cellar: :any,                 x86_64_linux:      "6d6489102b69cc9ea527e98fd03592e2b37ba99e6cf36619df09f99079abfac5"
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
