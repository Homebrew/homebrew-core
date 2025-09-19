class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.29.2.tar.gz"
  sha256 "28791a67b4e9b73322715067a78e17187ce517591515aad4724452bd60767eae"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63f8ca841bebf74ae7bcce73526d97ad3c99da0b3c570ab304b94bd46b86949f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63f8ca841bebf74ae7bcce73526d97ad3c99da0b3c570ab304b94bd46b86949f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63f8ca841bebf74ae7bcce73526d97ad3c99da0b3c570ab304b94bd46b86949f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3827b11dbeaababc4d08941b5af40d01325f1e13855905f92ea94c0ca9515e63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5feca89960959d0eac04aea5c0dc4d0ebc37a5c1bdbf38f67f9f3bfddb70f64a"
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
