class Draft < Formula
  desc "Day 0 tool for getting your app on Kubernetes fast"
  homepage "https://github.com/Azure/draft"
  url "https://github.com/Azure/draft/archive/refs/tags/v0.17.13.tar.gz"
  sha256 "577470d72285647e7a85a3c4c18d3bfe787180b36dd79ac86f2dcc1aad348708"
  license "MIT"
  head "https://github.com/Azure/draft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27c17c73595cdc1c9ab58222bd7c5da79118315f7d3a81bd0ae969a774bbfd93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acdfe376f2889fcf9c4a9b78da02486db3877b3895581c3b7511d7d8b3a38b84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "179c2a499691c7f98f5250215d1c781777635ac169e0968cbf414ae24d623c9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef805b1bf2ee0af2f16208b39745ac91aea55f5c0b840a7aa1ccd68ea7f8f2d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e25ed38ffef63fcca1d743ac697ca576a361ba124795ac633518a033debc3978"
    sha256 cellar: :any_skip_relocation, ventura:       "e3273bd83c47d8159e8adc62f3cd4a195401e7bd31351a376cea8ef098351f54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e263f231150b79d7ea82ee10347990ba170cc4624966a46ee6ee54480026eddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69ca3bc8252d3a2479a8774dc3c09298e553d36b3ccec5fc4539f2e9a8e16b14"
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
