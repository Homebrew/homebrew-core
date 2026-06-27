class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/main/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "29712008faa54cf481587bcc8f7b88c0e21520690d7aee7603b46198339139a1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b13c33e351da2689d4561ffd3b96c78906210bbbb1c1df12feee0f8b1cd2438"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b13c33e351da2689d4561ffd3b96c78906210bbbb1c1df12feee0f8b1cd2438"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b13c33e351da2689d4561ffd3b96c78906210bbbb1c1df12feee0f8b1cd2438"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6a6a5cae936fc61111bd434609b999361fecb0d0a7d49204ff07e72fe05accf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2adcf754c850a91aa5fd8653f923b5f5770f3c0d9e84ced84b940652fc890cf"
    sha256 cellar: :any,                 x86_64_linux:  "eda08aca7fa5f8161c6dfcc1a354871a11a47142fbaa302e56b658a23c5dcacc"
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
