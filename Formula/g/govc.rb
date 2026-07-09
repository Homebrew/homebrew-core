class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/main/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.55.1.tar.gz"
  sha256 "27432d6e0b3840b6e951885adc8316198ba80af26fe4bd2cc10a7a6bc680a5dc"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42f910573f21798382a25b5813519ce3c29f38f17b7e85e692ad2d25347ac8d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42f910573f21798382a25b5813519ce3c29f38f17b7e85e692ad2d25347ac8d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42f910573f21798382a25b5813519ce3c29f38f17b7e85e692ad2d25347ac8d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b12e10e2204dd9a066c50a27664f29fd64586e32ec853b75f2dbd01c33d58a7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29be85cd157420a525f846ac5d74b6d26f8bc77edd70815c39914ec7c926173b"
    sha256 cellar: :any,                 x86_64_linux:  "ba2db77355c7a1e0a9de1aff581199524cc69ec618ca899c85b639570cffc529"
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
