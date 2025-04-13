class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "238ceb04c754875427914f2819a8ae183763676fa43dec7c4b461453103c712c"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8450192da464f1262ca7ba2863b7d4fc24450ec2d4bcedf7494d0a3769336d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c341dbd2661839f61f984f2722bb79056e9604127f72ea3f34c13982b8d9e56d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5c9ed81764525592f39e7e089113f67fe26987456bdbdeee402b9241c68a723"
    sha256 cellar: :any_skip_relocation, sonoma:        "d634b3be32f1596bb3e5687ebe15b3619706c77ab48bcaf1b27bd7a3c422323d"
    sha256 cellar: :any_skip_relocation, ventura:       "6aa3d4499014fd4d14c5e3d9be1e9627f9d4c86ce398d091f7470a0a70093bb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d71ca9c85aa03e8ec67a12d4f84e9e23ec6cd371bb2147a9cdbd7a5376923312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7925759f8e8075375f68a72b02cb2937c964ac38760ca6cc48124c9928aa38e"
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
