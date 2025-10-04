class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/refs/tags/3.1.2.tar.gz"
  sha256 "9e0735b535c6ec12804fd4290bf7652eb557ea2361deddee90715277672b3da5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52bcf8f26b70dae8c8a79372591e010a60ca9cfb76fd1fed6d2e03b80e7c1d7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66e7455231f20bb7c4427aef543c2589891c7d71ef5b381b16004f837e6beebb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cb63990434cd132c9fa61314e1b24ded995543674c320a8bf425c514433fee4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2504c4dd3d65e66bcb085ba0995fdc31d9762d520a16977ba51cdda04d67b6e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7714e075856c8e2e67ef0bed627559e60b55952f70d7c3ab9397dff987bfd418"
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
