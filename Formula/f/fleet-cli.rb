class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "a4062517400b2429b673bf09e8fb09048a9ed97ea3b81a654292db44a3484d62"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "853ef2b13add544393211ded22cb47f9d31abe18edfce989317109a842cdb232"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fd61af6c4711d9039b8f1bc5f4efcab66161dc8129fd1935c08e35e5d145bae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92888df8225a84caa69c6ec2dfca89acb097216b4ec020c496f74dacbf4558f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "61a17408913cd6547cb2bb3d40761802e665d0e8f465bcd4ddb9c531cc4d852e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b3e977d252f076ae799478adee5ba94ac0356c7939d0745d9781b7937245b97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93679248c6bc8bdf3e5e02e83f49cdef3f10d93f35c033db529e9f5c5c4d981f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags:), "./cmd/fleetcli"

    generate_completions_from_executable(bin/"fleet", shell_parameter_format: :cobra)
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")

    assert_match version.to_s, shell_output("#{bin}/fleet --version")
  end
end
