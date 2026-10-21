class Draft < Formula
  desc "Day 0 tool for getting your app on Kubernetes fast"
  homepage "https://github.com/Azure/draft"
  url "https://github.com/Azure/draft/archive/refs/tags/v0.17.16.tar.gz"
  sha256 "ba8eaba15bf731e1127747a02a2d899a1f1f1632c3acdf0b51f4268866284d1c"
  license "MIT"
  head "https://github.com/Azure/draft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4d2f8c006c222be7bcfa778397218181e9c1182b306a479fe4ac60c75759ee64"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b3f2b8f4a8064d591822c34cdafaaca6cb79efbb855c0f7b06589137aa8b8a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1c45ce598c86af07942d298413286dfb5ae54b0b72f36a2e800b4e80689faa3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "621a7d89d5df87ff66fc0b07f851d3634d270bbad172f001d9781b4ddb430756"
    sha256 cellar: :any,                 x86_64_linux:      "cc3d24a14066ada3bf9071acc4d766fa7d86b1196605805f3d077679ae1d86ef"
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
