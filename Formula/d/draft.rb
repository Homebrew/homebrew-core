class Draft < Formula
  desc "Day 0 tool for getting your app on Kubernetes fast"
  homepage "https://github.com/Azure/draft"
  url "https://github.com/Azure/draft/archive/refs/tags/v0.17.3.tar.gz"
  sha256 "8d108f2bf9116f7a8e41315976cfb9b775985084dea3a4e14df08731ea0ecd3e"
  license "MIT"
  head "https://github.com/Azure/draft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61cedc332bf44912b75e16058a06960275e811c70d1e2674a5a6478b3d74df9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ad4308273f1c528ec446324bccfc6df19369d79c4d0056e2ddad45af20ab84c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d6528600bb2f93f7b69920b54e1b426a0e945dea339b1ed89be6972ba115468"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0df1289cdcc43b10ad1227db0f70ae76e4c4ebecb136663b51548b402e32b9a"
    sha256 cellar: :any_skip_relocation, ventura:       "48df67def42d661668e8952093ac314c779149e9c5e87f080933292911cce293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22f33a1e6e52e0dd165db4a3e79824ad527541b79ce57f00da55e236c3ce6ef4"
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
