class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.15.4.tar.gz"
  sha256 "e0bea02824b0168a499a7c2c9fa0f24fdb84379d421beaab35b0388da97806a1"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03887d2d474bb0c0fe25f4c4dcc31528e2c3e17813ab8c95a49c1ad4a8183223"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03887d2d474bb0c0fe25f4c4dcc31528e2c3e17813ab8c95a49c1ad4a8183223"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03887d2d474bb0c0fe25f4c4dcc31528e2c3e17813ab8c95a49c1ad4a8183223"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2b42c0598d5a70f0b854385827d4c2491037b9bf4c5c9792e7a07813fa90b58"
    sha256 cellar: :any_skip_relocation, ventura:       "e2b42c0598d5a70f0b854385827d4c2491037b9bf4c5c9792e7a07813fa90b58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc9689cb46d687112638b4cf9fc65d53ed7b8d732fb26f451fdb300566675366"
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
