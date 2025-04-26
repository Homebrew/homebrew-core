class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.17.6.tar.gz"
  sha256 "3894bb232416ad78f4c9f76d89246b2144f9139f3c349bc196f7d16375da030b"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "645a004abd627833c86bb712e1fe0f760a8f4b19a40182abad9dbac6a6e8948f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "645a004abd627833c86bb712e1fe0f760a8f4b19a40182abad9dbac6a6e8948f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "645a004abd627833c86bb712e1fe0f760a8f4b19a40182abad9dbac6a6e8948f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c693b99c62bcc27f250393f8bb6ce1a0895a3e04561fdec89ccff86a13ac506"
    sha256 cellar: :any_skip_relocation, ventura:       "1c693b99c62bcc27f250393f8bb6ce1a0895a3e04561fdec89ccff86a13ac506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a6ff6257f0311e3ab2dbc184f13122f3abd39d89d7824d7ddf5d3e8272d078c"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = "-s -w -X github.com/cloudquery/cloudquery/cli/v6/cmd.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end
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
