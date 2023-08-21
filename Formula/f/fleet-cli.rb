class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.7.1",
      revision: "991b71316757bbec6a3737f3bf3cd80205218978"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c78e2182b0deaa09f356e9ad20c05175c95bbe8d613148a76822f61d56bcd6a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e938480702fd8a1f86ba59b9af5d6cb657c6525d41dc8acece15a73a30981921"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e891f54ee2bc12c667ee56eebab6dee2707df99577fca90c877550ea1a8b1d97"
    sha256 cellar: :any_skip_relocation, ventura:        "fdad2120379d3b9072d9e9ebf9370e08fa413c8f2516ceffa687472798723d56"
    sha256 cellar: :any_skip_relocation, monterey:       "68bdcd79186ef807fb74c1d43cd17d5a470afd64477120551a5061f3ee5ed0f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca46b110a947a5a16e57adb4656eb0ef6d40c65bb4e21ab9520e16afa41a3e41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fa17c9055f3a150bcde3d2eb3abcc28a1f7ff5d0284b3fc7a2178777f974d13"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags: ldflags)

    generate_completions_from_executable(bin/"fleet", "completion", base_name: "fleet")
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")
  end
end
