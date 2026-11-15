class Cidr2range < Formula
  desc "Converts CIDRs to IP ranges"
  homepage "https://ipinfo.io"
  url "https://github.com/ipinfo/cli/archive/refs/tags/cidr2range-3.3.4.tar.gz"
  sha256 "68c4d30c33d4c2028e30c036b78aca7f8c987a5a83a3d82c515771cdcb2880a9"
  license "Apache-2.0"
  head "https://github.com/ipinfo/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^cidr2range[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ed1f6a33718cd9599007d74182ffb81c8951af956392892065bffcf5df0edde0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed1f6a33718cd9599007d74182ffb81c8951af956392892065bffcf5df0edde0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ed1f6a33718cd9599007d74182ffb81c8951af956392892065bffcf5df0edde0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "03a609e4c18ffa805a259fd21e61a199fb4165846b4e5026c5c50434e5c3b2e0"
    sha256 cellar: :any,                 x86_64_linux:      "0386358ff85e926961c81ae77cc6c687dad0326ca54059c9f5aedf3243609730"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args, "./cidr2range"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/cidr2range --version").chomp
    assert_equal "1.1.1.0-1.1.1.3", shell_output("#{bin}/cidr2range 1.1.1.0/30").chomp
    assert_equal "0.0.0.0-255.255.255.255", shell_output("#{bin}/cidr2range 1.1.1.0/0").chomp
  end
end
