class Draft < Formula
  desc "Day 0 tool for getting your app on Kubernetes fast"
  homepage "https://github.com/Azure/draft"
  url "https://github.com/Azure/draft/archive/refs/tags/v0.17.12.tar.gz"
  sha256 "3e117e99c479274f8b893b1e1edc359de0b13fc57eb99314c27d9f2d4c67fbb2"
  license "MIT"
  head "https://github.com/Azure/draft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cee57fe1d7b7a4a28de43b494526bd95dbcb234c1debe88492a1d7fb930255f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "083819bac8681f4bfc564c6a0c460e25133714ed3608d3482dd89cdf6cf10dd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3412aec724beb0811b5932087bceeb66cecd3c14e2d432be4d90ceb6a84f8cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "65a8a47ad936055f0f22c49706662647807f838d67c8c6b27aa34733b60bb185"
    sha256 cellar: :any_skip_relocation, ventura:       "9c5c9d590fa2610470ef0d024b9ab92d5b69fbbf171b1d9944409c44597cc218"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13cd95466e9ca07117b5555fa4568f1382a95228dfc2b380c9fb256ce4c2fca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a62682136071f98d719ce43e7df16d35842284729bb09a1cfeced67dd4f212ba"
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
