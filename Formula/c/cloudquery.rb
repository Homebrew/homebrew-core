class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.40.0.tar.gz"
  sha256 "392b6978fd122a64140a10b4c95ff02a965e0673bd547f30d7b32f7c796d0a96"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eab92898c0e006197638081638a46f16d3b29c8cc99d5b9eeff66ce42b6a1863"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eab92898c0e006197638081638a46f16d3b29c8cc99d5b9eeff66ce42b6a1863"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eab92898c0e006197638081638a46f16d3b29c8cc99d5b9eeff66ce42b6a1863"
    sha256 cellar: :any_skip_relocation, sonoma:        "29da5d4ca5fcc34fa80f074a82198c55bcb315b6fd33b5bacc911333bfff3fe2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8e49601de241be99d67d5177148e6d3a4f3d9035dbecc638eb64242a90a9bd5"
    sha256 cellar: :any,                 x86_64_linux:  "61c74d1d72559fc428f594550c91bf345fc7ec89ab0712adb1426fbbce58eb8c"
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
