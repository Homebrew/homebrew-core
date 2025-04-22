class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/main/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "a7ac42eaf4d17ac200c41c9339c75ccde1d3c5f0a2612717d8aa9fb546e8f123"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48372b131833283b67c2992acf00036af294053c74f21c75619916704bcb8496"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48372b131833283b67c2992acf00036af294053c74f21c75619916704bcb8496"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48372b131833283b67c2992acf00036af294053c74f21c75619916704bcb8496"
    sha256 cellar: :any_skip_relocation, sonoma:        "492793680ecbd7d26540ee17c43951840775e6254f456c3bc44cb723e82bbfe1"
    sha256 cellar: :any_skip_relocation, ventura:       "492793680ecbd7d26540ee17c43951840775e6254f456c3bc44cb723e82bbfe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cf0242bbc0c407679c85187b1c0c1ada1a2a5a4ffb55976a1f89180f6c46d06"
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
