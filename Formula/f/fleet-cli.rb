class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.9.1",
      revision: "b5f25c14d539d33a74bb2e85512f7918cbeea39f"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf28ea3257d671a778afdd38d52e9e1794b332310a67d7feb842ed2b03b733ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d008ba5f9038dbfb63b534553d8149214adb0a5a9efb0011761cb6400079a993"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b92dc604cbd073aae50f973ec1ceca23db1cb9bef2417fde40ebc21a029794a"
    sha256 cellar: :any_skip_relocation, sonoma:         "5236183e50e77997c3f3a9d7d4a763fd28f4d3851a1066115db881537fd82e07"
    sha256 cellar: :any_skip_relocation, ventura:        "f25391d95db980af1d445085033431909d01055fb8f63728bb850c9adfb3045b"
    sha256 cellar: :any_skip_relocation, monterey:       "405e8249dbf0d70d73aa571c64cc51f9e6d8386af0ab7f98de3a30bbfcf17de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1b0bdfdac7058b64749f9d40f4ba8c3907ae3846a9722fc6f148e9c071b6758"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags:), "./cmd/fleetcli"

    generate_completions_from_executable(bin/"fleet", "completion", base_name: "fleet")
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")
  end
end
