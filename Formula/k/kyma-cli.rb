class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/refs/tags/3.3.1.tar.gz"
  sha256 "6b51be95f4c2f5e7d1edc0d4b0dd60662dfcb01309ce8fd32b6bffdcf7b12cbb"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b2857650aad511a6859bbd23f0a8dfbc9d844b9bdfd2fd13ffed7c07d7d8e08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f597a01e25e8357d2554b96a3d197bab7db3188a80e28e9a740a79043e54be3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf8ca2fb70efb03f01becc66662a02ce5887fa802c8f1503b4de84b686f711b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c36e4fb091e8ca9a70c3cf4bec4b0fa1a059f99463b64b4b8ed2a29c28322300"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e78168e250054f1ddb267b060adab1e4c096ecebf334c674dc05b9c36254514f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9e3a3051c0ab24d090f521d47063c93537c175cb0bd2abb4169c42107cefbd7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli.v#{version.major}/internal/cmd/version.version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags:)

    generate_completions_from_executable(bin/"kyma", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Kyma-CLI Version: #{version}", shell_output("#{bin}/kyma version")

    output = shell_output("#{bin}/kyma alpha kubeconfig generate --token test-token --skip-extensions 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
