class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://fleet.rancher.io/"
  url "https://github.com/rancher/fleet/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "a176763f626b7658c444029fb24d823d0506765cf3245ddf8b5b1068d21f417e"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccf90b00eafe59a25efde9c84ec60261760ae07c18dcc85e2fae4c57698204b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebcf369151106cc85c84bb45a2ec876531de5c2b24071e8ca3579560cac5a55c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7705cae39064ba0316d1b671074c34223875997aecb7c40f2f127f415827f6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7958aa65fa5b9ffd00f1f72c70921bae5ea6ef711a769a78573fa4b92105d670"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1aa0264322fd11db01ea58730dc12c98c7038ad114d5cc4c34f1f09006f023f2"
    sha256 cellar: :any,                 x86_64_linux:  "1ae59da648e9551f0759d0a9378855c2e7af9eefa8aea8f9848babbfeedf51e9"
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
