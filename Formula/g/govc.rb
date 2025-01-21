class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/main/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.47.1.tar.gz"
  sha256 "ce71090c81e8b5fc0ad11e2320818188032c8317ae2fee1f3e1ab7512fb4ed15"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08e5a9052d021e737bf2bc2d0b302fa5e851cea18faf31118df87bc1390e1076"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08e5a9052d021e737bf2bc2d0b302fa5e851cea18faf31118df87bc1390e1076"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08e5a9052d021e737bf2bc2d0b302fa5e851cea18faf31118df87bc1390e1076"
    sha256 cellar: :any_skip_relocation, sonoma:        "774dc353aadb628913b365800a2f4c44b26586d1518a09bde7417caab35e9ac9"
    sha256 cellar: :any_skip_relocation, ventura:       "774dc353aadb628913b365800a2f4c44b26586d1518a09bde7417caab35e9ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac0749aa1701e44001508fc3258fbe2953da03baf6d3155d5490f557d0b83848"
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
