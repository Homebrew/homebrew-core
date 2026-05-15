class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/main/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.54.0.tar.gz"
  sha256 "6f38fcf2f25fef287ddd8c14cc849c69f3b70771a9ed03bb77556191ba869f0a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "264288b4e68f25a37ce93917d5a3ecfc45a7826f967f9259750997350d174456"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "264288b4e68f25a37ce93917d5a3ecfc45a7826f967f9259750997350d174456"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "264288b4e68f25a37ce93917d5a3ecfc45a7826f967f9259750997350d174456"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb75c842916633b60b957fbafcae2863f468b5a1ddea74b77aefa48cca5ad2c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fc719e2a2e5ef4cdf06ed2c10fc7300d0e0bbc2e29f5b5ddf65389fb208bb57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49c8212d726c4ba5fcb45fda34aa3190c53538cf0e7a81798c7fbbc8b543b08e"
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
