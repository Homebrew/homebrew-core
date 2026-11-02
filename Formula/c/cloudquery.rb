class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.50.0.tar.gz"
  sha256 "2fc50344a912e0995ceab084738f5cd5f56afe9cf58d9c728c2eadc1debeb7a7"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "925bbc6b96c0b482e33f82b29b6ef84dcc5f91863802ae57dd8b7002e6363b76"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "925bbc6b96c0b482e33f82b29b6ef84dcc5f91863802ae57dd8b7002e6363b76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "925bbc6b96c0b482e33f82b29b6ef84dcc5f91863802ae57dd8b7002e6363b76"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "80c8411d0b14a2c66c7e0a1752ebc935bac5999970166466d1da958b0ffb16d2"
    sha256 cellar: :any,                 x86_64_linux:      "3063b81573d5f284fb065f9da38e9f6da0fea97e2e1fd5bc29deffefef6f0a5c"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download", "-C", "cli"
  end

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
