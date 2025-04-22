class Draft < Formula
  desc "Day 0 tool for getting your app on Kubernetes fast"
  homepage "https://github.com/Azure/draft"
  url "https://github.com/Azure/draft/archive/refs/tags/v0.17.9.tar.gz"
  sha256 "819f35b3ca043aa5a8a5abbd7d6d7af8695c6fd2a376c8272e67958868181c93"
  license "MIT"
  head "https://github.com/Azure/draft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb38e776e4f2a3fa5efa4a29d2f4b63cbb9b696cef57a2eb4201bf6f5fd1f225"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "641ed6a410905b717cf0e038365704ec4de3eaae2371ecb064c58225ac0844cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "179a45d73d3a2804ce2ad7d8052398fdfdc4c6a42ffac6b48a2cef1d931e35b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ef0386c6af5dfa9c076fe15c63e5c2034b242969f9158bfdf8db74606850db1"
    sha256 cellar: :any_skip_relocation, ventura:       "854bf7b61b52c856bbf9ba8bfb84e46a3b589fa837af6677f08c5baa433a3963"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6211531d5cd02fa4c0aa4a071fd7675abee236d30b80f963b69f014c895015d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ff10e8fa66e4fcb92f224ae35c72e04e5fd07bc3920c383cb7bc99c3d4618d6"
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
