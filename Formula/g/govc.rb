class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/main/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "16bab6e95ba7919166e1231e0a783e945cf72de51e77a0c1efcf300ddf4a917e"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd44a9637a14fdeb322fa4c84240a4d43752e5a6cd7a85f6b691eae5aa27bb14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd44a9637a14fdeb322fa4c84240a4d43752e5a6cd7a85f6b691eae5aa27bb14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd44a9637a14fdeb322fa4c84240a4d43752e5a6cd7a85f6b691eae5aa27bb14"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a027fc353987aef295e4f192349e3da4f97d877e429402d16644ee528f1338c"
    sha256 cellar: :any_skip_relocation, ventura:       "0a027fc353987aef295e4f192349e3da4f97d877e429402d16644ee528f1338c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca7b4b885817b1c09c617dcb19533065959e4217abeac3a1b37d3b4df8013fb6"
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
