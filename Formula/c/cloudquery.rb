class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.36.0.tar.gz"
  sha256 "f02da98440013a2dd9e0dc667a127060a43881bfd2b677f1f8eeaf34738bd8ae"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6e092cf84240ba0e0eb905b2d2f4c611fca4bd65c71557b1e0d496b63a2a96f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6e092cf84240ba0e0eb905b2d2f4c611fca4bd65c71557b1e0d496b63a2a96f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6e092cf84240ba0e0eb905b2d2f4c611fca4bd65c71557b1e0d496b63a2a96f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf5a11b6fafeda2578b22f9f930c8b9ffd5c9a4feea0283db753c561a938b15c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf042613692516094db2bb6f42507e7a8f400f7ff27435ea0f6cf500d174848b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7610106fc6c16c38515e573b2bd661841395b798a8855f9e91b06d0531a2c54e"
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
