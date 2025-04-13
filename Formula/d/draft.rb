class Draft < Formula
  desc "Day 0 tool for getting your app on Kubernetes fast"
  homepage "https://github.com/Azure/draft"
  url "https://github.com/Azure/draft/archive/refs/tags/v0.17.7.tar.gz"
  sha256 "0db6741661494fa12835ff8edc34b25e1901a1e08aecbb69f69601001213159a"
  license "MIT"
  head "https://github.com/Azure/draft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "640c05423dc6f2c489ce466fe707adc1d14326b45703afbb328b553810824dc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c92c674c591014989bab56e8feecc1266733230f3198312ddc7b144ee19f250b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "541fb3a73035308b2d1472fbd74acdd9d15cfb2448e85fe6e39f5c3cbc7e26ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d97a59191d8f28006ed2c83fdca02836ada1afaa0277e8b9520c3d44f4f0ab9"
    sha256 cellar: :any_skip_relocation, ventura:       "cb6b9261003890b3b60ed6cb5f5cadd12f9fa4b4db6ba47f39d5dadc730ec9fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "969ee85f543b2c8ac52572e8e4998724a10889b5b8885f69e9d3c943de8ae872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "133f8b2033fa822423ef45e59daa5f9bf5c816a49707bdc51273a445df8b0a57"
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
