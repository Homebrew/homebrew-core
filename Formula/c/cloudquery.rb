class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.37.0.tar.gz"
  sha256 "d4fc672963230459f18c47136ebf36baeba2ca208067e2d39cbad497f9320ae4"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b00ed712f93c55a23dad4b4ea5f3debba844119077022c3c38f80361be4e2ac2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b00ed712f93c55a23dad4b4ea5f3debba844119077022c3c38f80361be4e2ac2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b00ed712f93c55a23dad4b4ea5f3debba844119077022c3c38f80361be4e2ac2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d6abe70cd46f44e8ac68a32b0be401c7fe0bba408f8dd3295ca8608372f8e20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89429e145bd49a3fd39e8c233647fe62d7da0a4696c21141de68a0b79c9d5757"
    sha256 cellar: :any,                 x86_64_linux:  "f6392ba0b903364e75949af30d3bc20e3308040366ef1e9bfb99e1e43e46ff4d"
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
