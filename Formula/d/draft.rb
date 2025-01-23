class Draft < Formula
  desc "Day 0 tool for getting your app on Kubernetes fast"
  homepage "https://github.com/Azure/draft"
  url "https://github.com/Azure/draft/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "eee0a43194eab56642077d165026f9d4ce88dbfadb790262ce1a23c00d7df221"
  license "MIT"
  head "https://github.com/Azure/draft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bfa153dde9851a07d37ac84552d06fa2a2eac39c9b613aef47ee2ee8f8b24bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48d293f69e442d42acb4366f7547b94c052a775b493b7105ad894462a224ee66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ec4d6f1704fa68aaeb35270f979474adb66b5cf1d153b5658d258cf93b3037c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad21742c91a31abd481d0d738001e39cf35db25142ec564a7cdfdfcdca736614"
    sha256 cellar: :any_skip_relocation, ventura:       "55512d695b94a6d59d8f0e9d5d8bccb6343bacfa93e000378b733511e02cc1dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f095f794665b03ccf14bd44398353680d0e5fb9738965adf0857a17690d1b1f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Azure/draft/cmd.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"draft", "completion")
  end

  test do
    supported_deployment_types = JSON.parse(shell_output("#{bin}/draft info"))["supportedDeploymentTypes"]
    assert_equal ["helm", "kustomize", "manifests"], supported_deployment_types

    assert_match version.to_s, shell_output("#{bin}/draft version")
  end
end
