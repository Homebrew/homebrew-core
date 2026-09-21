class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "2de1f3ba46cd9a82c0a40c9be7ad3cabccdda9fb16bd2d70c6ab113d21b145d8"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "21f910c40b37b462d047a84696032bc5b05b64620e012188e1cdd8222191e990"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f168787376d537f815d9f1a584477d472f80ece81080b856b01364e0af5374bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2e0a0be62f963692720195f1f49db4cba465f0caca84c1a6a664db59241b32a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "f5ac69c8d0ca8226821a85cf1f1d6d61be1be96385896a3bba11237f3171bf6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8b562d4ea9cfb837141ede2cd3e4e365d704dea24f6c7f753c37410266345421"
    sha256 cellar: :any,                 x86_64_linux:      "cbcc69380ab79212acf1b5e0aee636a0706e282bcc448b825e3b164da64f39b8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "failed to create backend", output
  end
end
