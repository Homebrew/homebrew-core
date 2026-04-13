class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.35.5.tar.gz"
  sha256 "a785d3fd61d5dfdce60c8e3a5e1eff68bbcc7a910b55390265a8aeacdffdeec6"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae2752ee4dac84c129cb5bf56a02047f942ad522787496c5fbdd6df8d410d4d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae2752ee4dac84c129cb5bf56a02047f942ad522787496c5fbdd6df8d410d4d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae2752ee4dac84c129cb5bf56a02047f942ad522787496c5fbdd6df8d410d4d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1487848b6e63a38b846eca078627ac8d5c8e9ab1152337a42dc75d73ad89be46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "553f4687e25cbe5205296f0f911fa2ec4ea8426a836f176cfc81a2d4b9770b23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "472d5b2a42511639acede99263c1331e1b621528766b21b6976468d1e9de226b"
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
