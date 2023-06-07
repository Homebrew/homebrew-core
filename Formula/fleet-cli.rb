class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.6.0",
      revision: "26bdd9326b0238bb2fb743f863d9380c3c5d43e0"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "923d11053d357c0b6087cd8fe29ec9b1050a0962c6a3dbb0988e511d36e0019d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d4158f6690e7ba4c1df39bc1454886a4eeef9e9a3056aeaa249c866bf49e7ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "724f06a916ef4be66c176bdd831b3c3513743c8739df8114ea3fb5f3d558e7d8"
    sha256 cellar: :any_skip_relocation, ventura:        "5828e6576b28ec53bbebee4fedc1ba80cd98b37eea352b4d16aa04b683afaf85"
    sha256 cellar: :any_skip_relocation, monterey:       "5f9e87274ab1734a4f24e57853eed76ebff83af319e0d0446b8033f9e8e18303"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a8d713fd4e3c029c6bec7ce334323e889d7e38a7de57210d35805024e42ce65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3eca51737e3dda51d45826b858815ab80a3e015bbc21f1951d4c9f9b08cf0734"
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
