class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "17dd712218dc408e67cfa62093486f325700aedd983e42c22f62294d95c39d71"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34017ca0bc4c9a1eaa472bd91c6979d73e2a431f6a95947284b740597815ee8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8f25c6a4cf7a866eaf6b994ec2cca36a0d7d933df061962ff96f3f2191e5ea5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c18484071c3be9b7548851a6b20462bc73c4ebc9ee6c8caafd00a407bc828d5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "892b85a66c7af5f284115a5c1ecd95d12088c12f44f775b8795637264d074bff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7563a4f08ea3c2cf1e8f33361876849f264ee0a49cadeec7f8a179f12ddc8562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0a5169d05b779c4d0626ec8b00123fca6eb1b51c2a6ca4d070807c4a36b29c5"
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
