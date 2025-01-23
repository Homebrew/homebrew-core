class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.14.0.tar.gz"
  sha256 "6eac726632b754dccb69ee5b41361d5d3df51f0fab089ca30a50edf9fcd478e6"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca6e02013a689e89d9220003597a4b4716da16a2cf974fc8fbb719d5b125461c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca6e02013a689e89d9220003597a4b4716da16a2cf974fc8fbb719d5b125461c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca6e02013a689e89d9220003597a4b4716da16a2cf974fc8fbb719d5b125461c"
    sha256 cellar: :any_skip_relocation, sonoma:        "691adce2fcd228be75ab1533b9601abbc9ab5183672eb9afd247986a59b0ade6"
    sha256 cellar: :any_skip_relocation, ventura:       "691adce2fcd228be75ab1533b9601abbc9ab5183672eb9afd247986a59b0ade6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e7c79c63b3a886f9216c98c2481086640ba4a8a331e1498b7b2c05cc7c76be0"
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
