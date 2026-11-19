class Draft < Formula
  desc "Day 0 tool for getting your app on Kubernetes fast"
  homepage "https://github.com/Azure/draft"
  url "https://github.com/Azure/draft/archive/refs/tags/v0.17.18.tar.gz"
  sha256 "3dcec7ae0e5abf39cde7623fbf2ab392f02b08107516f22bc669b6ba3e8031ee"
  license "MIT"
  head "https://github.com/Azure/draft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d60359ddbfdcea26ed7155b8020f38b36eb6c38ea2848c7012d5ff9443c05e82"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4a313266620d1e7e5875a75b6e7669e6c196285e2d78837fa9206def51fd5919"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "30af94f1028e37eedb917169c5cf1ffb889aba77da37a120da1b662640abdd5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "82ca7f2778cc72533e826e8ef903c5c0b1b40a086c017777c7b6f7dea391e20e"
    sha256 cellar: :any,                 x86_64_linux:      "265dd374bb22e00163b25aaa28a8a136eaea3ca2364228b72ddd58cebab7a580"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/Azure/draft/cmd.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"draft", shell_parameter_format: :cobra)
  end

  test do
    supported_deployment_types = JSON.parse(shell_output("#{bin}/draft info"))["supportedDeploymentTypes"]
    assert_equal ["helm", "kustomize", "manifests"], supported_deployment_types

    assert_match version.to_s, shell_output("#{bin}/draft version")
  end
end
