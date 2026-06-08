class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.36.1.tar.gz"
  sha256 "726ee4d2feb8ff2404ef7a8d7b5b48eadd2ce2cf54520087e451821ec8f14d07"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b49a7baddf42814230b96d79b93a5acfe0d7731ce09274ae81e3861aa6eb230"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b49a7baddf42814230b96d79b93a5acfe0d7731ce09274ae81e3861aa6eb230"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b49a7baddf42814230b96d79b93a5acfe0d7731ce09274ae81e3861aa6eb230"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ce0a756bc67f912c794ad2f54ad4cf960a74d9983ff39b2fca1e955ca53e372"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c01f7f77c960edeafbdb8537391b8b56c67c8f25f098d87f9b665baa62081f5f"
    sha256 cellar: :any,                 x86_64_linux:  "03a35b4ff31b79d1202af50960072687c6454f28492f6886940c07c15edef86b"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = "-s -w -X github.com/cloudquery/cloudquery/cli/v6/cmd.Version=#{version}"
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
