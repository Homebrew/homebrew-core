class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/refs/tags/3.2.0.tar.gz"
  sha256 "9f58ca3c898e450aee12211cc47ee9bc1223e3fc1591dc9b467e1406b28dc639"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f209e2271622adf9239a1fc7648d2ef0562f03e4c278bf602422860801bb16c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5714006d511f9702519770c3a34c1f981983dc352cba5eb777d38c528205a730"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cae4cee86f16af89e8b4f5d7b4f35bfc94f58da7e4a29839cd399649bb2fb09"
    sha256 cellar: :any_skip_relocation, sonoma:        "dead6a1dcae6de0d7e730afbca1d3dfd45c9e3567d6902d495ce04498dad1adc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "291fb973bca696f80ebedb1325499d8255125dea3872b8da0cbcdb7c92c4aa2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac83d0fc00d3e3477eb8c977ae06edbd3e9e1cbae36e2478b409de5fa53ffd06"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli.v#{version.major}/internal/cmd/version.version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags:)

    generate_completions_from_executable(bin/"kyma", "completion")
  end

  test do
    assert_match "Kyma-CLI Version: #{version}", shell_output("#{bin}/kyma version")

    output = shell_output("#{bin}/kyma alpha kubeconfig generate --token test-token --skip-extensions 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
