class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.35.2.tar.gz"
  sha256 "861bc6feccb4d2e81fc1f3a9856408abf548216f638cb7ced4d8ef24a56281be"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cb042c8129896c9d1175bac359c410d2a8edcdccf149a27336cfa25d80657e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cb042c8129896c9d1175bac359c410d2a8edcdccf149a27336cfa25d80657e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cb042c8129896c9d1175bac359c410d2a8edcdccf149a27336cfa25d80657e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8b34fed0ddaab07b63c020fad5717e23e8e524e69391b7923383df794f52703"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b87e57702606123dfcc3a5a1b314abeef2e703667f5ef6ae056f8d6961c7b3fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3e72f06acd7f70b651f5851ec36eba15d5588d9a0e9e8b53138e20ce859c36a"
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
