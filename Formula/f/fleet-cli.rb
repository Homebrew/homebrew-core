class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://fleet.rancher.io/"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "95c60643fb1de6c3f9d22ae3ddf02d334e91cb3160b8cf71d06d289cc345ddb9"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75f2e274897b2103149a1178683839796567e310d50e5799a733257fa01687a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7582af24149d23125e1a4720faa697fedf19ec180a8551441e926dc7761664de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca9f51339d4835bec662b474dcef6bb381c80593c00df14e3bb20df360acea58"
    sha256 cellar: :any_skip_relocation, sonoma:        "a16f44c78282c598f02dc4b4c017633673cb8c00c0412a03e36ef9f9348390e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aeec16d964fba65735f07151d6a3e26e5c5d3976ffe37f55ebeb7a690c6278df"
    sha256 cellar: :any,                 x86_64_linux:  "a06a660176087be292078277c087243c98e2df73007d8516d0a787ec06e4bb6c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
