class Draft < Formula
  desc "Day 0 tool for getting your app on Kubernetes fast"
  homepage "https://github.com/Azure/draft"
  url "https://github.com/Azure/draft/archive/refs/tags/v0.17.14.tar.gz"
  sha256 "515e739765ae855e9a19a6de94d6f2529b11eddb707e1f8ee61867be7cd2b06b"
  license "MIT"
  head "https://github.com/Azure/draft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d421ee84bd5e9645501210f787dbab90fb8397488f4886b100cfde2ea76056f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa70d3160f12bcfcb745032d00f548e965e2c110ab8ea7b920d55d6724412f53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08a267d3651f0c9a3cd68b09f4899adbcbe5dc866091da7d5ac1d1ca16014a91"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad7fa2b985e02b879f9fa933fcf45d247293bab01ddfbd48cbf48ed7b398014b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a69f7663d99a27e99c89e5bf08c40cd0bd48102a4cf9817d298b95eddde7688b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9389136adfb076edbd6f0b449905aaefc9f0ad5905e10fe2e571e37f18c7a925"
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
