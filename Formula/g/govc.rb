class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/main/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.53.1.tar.gz"
  sha256 "ce3b0862e628f4cb487912b0e7953e95dfe642679f013c0ba1826870f2bdf3ab"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65b6f5e7a5a56db60aeb8116ac99e5ec2abef19ab40a3688c3c9eddb2a41a332"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65b6f5e7a5a56db60aeb8116ac99e5ec2abef19ab40a3688c3c9eddb2a41a332"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65b6f5e7a5a56db60aeb8116ac99e5ec2abef19ab40a3688c3c9eddb2a41a332"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f78f45d4c2c369eda88a43927d68b18a67fb28930076ec2e1a3cc6dc9f60203"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f60343ab86974c998145ec187847ba5bf65599d943660502ac68c04824c966cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1caa427c55c7bb72538c4630dac039f87272470507474ce614b7b072c9464b58"
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
