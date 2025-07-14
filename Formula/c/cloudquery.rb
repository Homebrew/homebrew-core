class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.22.1.tar.gz"
  sha256 "a08eed7f7e3f0cf18a665b9d5c4fa35aebb4a005e127f11b1b827d1b301888d7"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3555b6d45a6bfe5bdd263349f0f2fe3dfade4950d97cedae91072077e3b360d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3555b6d45a6bfe5bdd263349f0f2fe3dfade4950d97cedae91072077e3b360d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3555b6d45a6bfe5bdd263349f0f2fe3dfade4950d97cedae91072077e3b360d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f4e53f45c040e8318eb274b35e11ad3c06b42ea1dbb5acecdbccd02d9b4df82"
    sha256 cellar: :any_skip_relocation, ventura:       "6f4e53f45c040e8318eb274b35e11ad3c06b42ea1dbb5acecdbccd02d9b4df82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97273a4e7f7a263f131077b4ed27f592846a2faf2a08f9fe2b5c8bcdbcfcf8ee"
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
