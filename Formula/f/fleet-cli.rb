class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "e49835f0f1d424583dd5b6e13a25ffa5f96bfa2ddf4b0133900c3502d0dc1da0"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abecbb06140217ffcc49a8638be9803411ff4c7aa295bdf8d140420e9955918b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94ea71f74920617aff7d7ef1ff4d4101bb79edec77694e3680567bec71068cf0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cdeba3776ebe4940337b2cc11522c21f9df1b1c92388abf29e28acac5e446e48"
    sha256 cellar: :any_skip_relocation, sonoma:        "31be2e6cadffd4dfe01dbed4d78db99b8bb768662708584fd3905e9e71e55212"
    sha256 cellar: :any_skip_relocation, ventura:       "b88d99439b80ec3cad4974219d18c49fe8cb913fe53936998022a89fb9bc3265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b079ef48119b31413b8d40b159de1a519dc0f2cdf58e0343ad8005b3161c45ad"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags:), "./cmd/fleetcli"

    generate_completions_from_executable(bin/"fleet", "completion")
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")

    assert_match version.to_s, shell_output("#{bin}/fleet --version")
  end
end
