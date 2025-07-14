class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/main/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "cbe78d0ae765b99c32cae333316291a0a4d00d16cf82abc065427e86161ad374"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebd5172d61957ee2053debefc8d38e72eea8761461c51d1de10af33b0c76ddbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebd5172d61957ee2053debefc8d38e72eea8761461c51d1de10af33b0c76ddbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebd5172d61957ee2053debefc8d38e72eea8761461c51d1de10af33b0c76ddbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2635ac6aa91646a9f472784c89bd7bf7aae81864b7a9346c6c058f68d18fa69"
    sha256 cellar: :any_skip_relocation, ventura:       "a2635ac6aa91646a9f472784c89bd7bf7aae81864b7a9346c6c058f68d18fa69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71e648f83b6b2e0d7d9bcecffe225a796b7c9d99ffc268d8506d31e425d40a85"
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
