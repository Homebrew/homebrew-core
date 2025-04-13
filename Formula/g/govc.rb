class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/main/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "ef926a2ca5e34712b11c287c5458e1a3e2ad66d443b3dfef2dd7ffeaa4e267ec"
  license "Apache-2.0"
  head "https://github.com/vmware/govmomi.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8b33dc2d4548a54cb91ae5ff5f439da1fdb2a63a5314cb4153f537b2e13fd5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8b33dc2d4548a54cb91ae5ff5f439da1fdb2a63a5314cb4153f537b2e13fd5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8b33dc2d4548a54cb91ae5ff5f439da1fdb2a63a5314cb4153f537b2e13fd5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e37f40bb734c39b92bc3e463ebd08da3ffd7a3d80c748b73bd8da5773d68714"
    sha256 cellar: :any_skip_relocation, ventura:       "0e37f40bb734c39b92bc3e463ebd08da3ffd7a3d80c748b73bd8da5773d68714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b708ec8516805169525d9b3406dff11b91c56832d0ce7031eb0a4659ba2c6932"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/vmware/govmomi/cli/flags.BuildVersion=#{version}
      -X github.com/vmware/govmomi/cli/flags.BuildCommit=#{tap.user}
      -X github.com/vmware/govmomi/cli/flags.BuildDate=#{time.iso8601}
    ]
    cd "govc" do
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/govc version")
    assert_match "GOVC_URL=foo", shell_output("#{bin}/govc env -u=foo")
  end
end
