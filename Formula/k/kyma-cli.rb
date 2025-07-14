class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/refs/tags/3.0.1.tar.gz"
  sha256 "503a7a248e6c5bca55ddaf2366203c7e6f161335bcce9dc253d88e381c48732b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e6685e148e4932a54e960c004c4ea707c6309dec3f065271c0182d12679d7f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e6685e148e4932a54e960c004c4ea707c6309dec3f065271c0182d12679d7f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e6685e148e4932a54e960c004c4ea707c6309dec3f065271c0182d12679d7f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "365cf27c9193c8fbe476ee376c8743c8f6f98630499c559dd3f0dbe18892fc50"
    sha256 cellar: :any_skip_relocation, ventura:       "365cf27c9193c8fbe476ee376c8743c8f6f98630499c559dd3f0dbe18892fc50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85fb16be6927220bb2a41a5a70019fc37c6a7ef3b2f5758000024205adf57752"
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
    assert_match "failed to create cluster connection",
      shell_output("#{bin}/kyma alpha kubeconfig generate --token test-token --skip-extensions 2>&1", 1)

    assert_match "Kyma-CLI Version: #{version}", shell_output("#{bin}/kyma version")
  end
end
