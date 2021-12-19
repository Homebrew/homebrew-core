class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.0.0.tar.gz"
  sha256 "e686577464c849c85e6c6fe0d4c84b33cd6e116107fc7e437d4013ba71a48b6e"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05ebce0c8616190dbb5b5e55597a690e53e9a0d921dae479bce49262de72d8c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95fdc62f454d0d75f4f01a87d093d44292cb45818d40316a1395e3f7a12f31f8"
    sha256 cellar: :any_skip_relocation, monterey:       "a85fcbdc51d609926098d32e540ff5d4886bf26945d43561f67fcadff38cf3d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "c07f8365e38ac5d7695c3603736d32d0d1af0f2cd9d85aedd94f0bda33b51a44"
    sha256 cellar: :any_skip_relocation, catalina:       "48c216b398f1a79e999175c2b46e797288c12d10689de2bf0151ca153a554ceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c16f8f663af19925fcb69e2cfdea235c9b7cdf3b44c08974f8ed1ccfb51c155"
  end

  depends_on "go" => :build
  depends_on macos: :catalina

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags: ldflags), "./cmd"
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma install --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
