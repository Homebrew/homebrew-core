class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "88bcc4c2dd3cb2c23a1214dd1aed4113f17a7d9c8a3370f69d7264afe7de462e"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ceb97e71a29896288761d41d1b4f3488c978751da329882e1182ffc33667ea70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e4f749248a449c225e17df68ed854d31da374bf8439741006a4f241c1220f7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce26fcf3c34996bfc1c5bc283a5083b2264aa5b6bfb447820406525b208c31d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4994db618498a04d4e3bb1ced22f2ffbdd68022abd1042725ee5f17691b64e22"
    sha256 cellar: :any_skip_relocation, ventura:       "d98c1181447c9f7650122a553ddea74d0124a13ed3038ad588497eddb944e066"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33816d5713a4a0072c820f7dd311f14f9f8910c797f99872ff81272e2641677d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4585264fb80ca1ee633a79e2fee303a54f7d0491fcc3c2598c8f524653fb3c2"
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
