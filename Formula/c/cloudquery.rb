class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.41.1.tar.gz"
  sha256 "4c9e9de06b2fbeea08ddb7ed303d389d6bd3b4f344adcd2f619d391dae359432"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23c13a8f0c88939e55946c9dfa6e4c9732c97acb278121b09a9a02594fc53f75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23c13a8f0c88939e55946c9dfa6e4c9732c97acb278121b09a9a02594fc53f75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23c13a8f0c88939e55946c9dfa6e4c9732c97acb278121b09a9a02594fc53f75"
    sha256 cellar: :any_skip_relocation, sonoma:        "14a220cbaabf300379b10a1462983e2911e9e2ab1236299acb6ce584b025f0c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "074e9f65d2320aeaac719fcb6fd30e79dd950e809dff41b0dc1da36f88482fb5"
    sha256 cellar: :any,                 x86_64_linux:  "34aed42c36f3f1d9ed9a4475f4ce27c4121335f8a630f5dc3f4612b79c9e1edf"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = "-X github.com/cloudquery/cloudquery/cli/v6/cmd.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end
    generate_completions_from_executable(bin/"cloudquery", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cloudquery", "init", "--source", "aws", "--destination", "bigquery"

    assert_path_exists testpath/"cloudquery.log"
    assert_match <<~YAML, (testpath/"aws_to_bigquery.yaml").read
      kind: source
      spec:
        # Source spec section
        name: aws
        path: cloudquery/aws
    YAML

    assert_match version.to_s, shell_output("#{bin}/cloudquery --version")
  end
end
