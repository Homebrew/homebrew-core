class Draft < Formula
  desc "Day 0 tool for getting your app on Kubernetes fast"
  homepage "https://github.com/Azure/draft"
  url "https://github.com/Azure/draft/archive/refs/tags/v0.17.15.tar.gz"
  sha256 "23785d71403c0d155aee3d268f3914221e742cff62cea8c42f2abaae82bedadd"
  license "MIT"
  head "https://github.com/Azure/draft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76186fbbe34681e46a9862a5b1279344afa95b170ce818a151d6a8f02765301b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c39d3d6452629cc89c9a28911a8015a0d8b4c8ddcac9fa833c2f56ff906984e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a99e0f9a2ea4dea78288bfcdc22cca13a14e2be7e7bef812f6fc705099ff80d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "004ab25ff84af3a6a1d261aa0eed9531a118e77217542857a7a749d39c88cb79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e88c23179a3561b28a364525e6da35cedc8659579444ab745342bcafe0ee8373"
    sha256 cellar: :any,                 x86_64_linux:  "474b205c1493774191f1e57e428a5a5d0a79706b2b31a116e2b6bff6f40dfdb1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Azure/draft/cmd.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"draft", shell_parameter_format: :cobra)
  end

  test do
    supported_deployment_types = JSON.parse(shell_output("#{bin}/draft info"))["supportedDeploymentTypes"]
    assert_equal ["helm", "kustomize", "manifests"], supported_deployment_types

    assert_match version.to_s, shell_output("#{bin}/draft version")
  end
end
