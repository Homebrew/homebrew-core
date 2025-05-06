class Draft < Formula
  desc "Day 0 tool for getting your app on Kubernetes fast"
  homepage "https://github.com/Azure/draft"
  url "https://github.com/Azure/draft/archive/refs/tags/v0.17.10.tar.gz"
  sha256 "87486abdf9cbd45de4146a3d80ea1e08a46ecc3e018382a52968de9ca4aedfd2"
  license "MIT"
  head "https://github.com/Azure/draft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8fa2caaa95f051b5114e447b8fbdae51b54739a4c6daa7b84fce1e64d08a96e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10c3f0e502da1e148f89389876e70dcd552f55f76ee4e941e2c465f10c111dbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "566351c1619f024b65a2ec36bc720121313be80b1a316f442f710ec597d3bd25"
    sha256 cellar: :any_skip_relocation, sonoma:        "8941b472e637d3fa1623b4a8326044a8819a8730d682e623d356abc6dbd42c83"
    sha256 cellar: :any_skip_relocation, ventura:       "9bd6770e661e90564d36c7e2d65191a595147c7cb56ed5fd120094eed92822ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43e900f5dc9888b8dc5f32f8f0663aa0b0a0778c6ae8ccbc1cb18690fd49671e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4bf653b0d28d85422fc63a577f1b6a8cec6cfa739c4332a3267baf9e6a5c33e"
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
