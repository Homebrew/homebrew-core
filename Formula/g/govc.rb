class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/main/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "3d5357eb00c1093d46d265a8ebd488e9d2e1b5a6143c81f124a3deceeee3dfa2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d66534f8466e833310a4fa11b97225d562b96cd479e6ede30c15d36ae901f39f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d66534f8466e833310a4fa11b97225d562b96cd479e6ede30c15d36ae901f39f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d66534f8466e833310a4fa11b97225d562b96cd479e6ede30c15d36ae901f39f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9981b1263678ff02425890ff57fff7a32464987622dcc2046deb11923397bfcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95040e435b9285c2472b5d4cef02b03ea6902fabb732c33d626b1fb83b9b4e79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7d69eba645d67176308137ef01dccb55fdcee7d3acb96c72b0602400caf1820"
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
