class Opkssh < Formula
  desc "Enables SSH to be used with OpenID Connect"
  homepage "https://eprint.iacr.org/2023/296"
  url "https://github.com/openpubkey/opkssh/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "3cd05f22e2ed2293b28c3223d1482502ce14b9e5e12ef5d54b68855566cfb33e"
  license "Apache-2.0"
  head "https://github.com/openpubkey/opkssh.git", branch: "main"

  bottle do
    manifest_sha256 "9904dbba34f2ab3ece718cea3247dedf9acb1472c1eb2f755e8cccf5fedad3b7"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d08fb6876cd0621504b1c88e67e00a4a2de5e50b903232cb16ae01ec01863176"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d08fb6876cd0621504b1c88e67e00a4a2de5e50b903232cb16ae01ec01863176"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d08fb6876cd0621504b1c88e67e00a4a2de5e50b903232cb16ae01ec01863176"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9e6ae416e4b81b101648059e527ad0e7a87ff50d3bd83b88840981c2905a0253"
    sha256 cellar: :any,                 x86_64_linux:      "7d095e4155157293a1e0720710386607851142dbbe886bef488da8679218eec2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opkssh --version")

    output = shell_output("#{bin}/opkssh add brew brew brew 2>&1", 1)
    assert_match "Failed to add to policy", output
  end
end
