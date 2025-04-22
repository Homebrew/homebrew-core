class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.17.5.tar.gz"
  sha256 "6555e7267644c3b9c50d8b395ebc5e4d0290aa68a694cf2b01b5f32b5f7351f6"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1162b42a095b3659bb27add7096113bfebf2920c5a80fa08cb468d3c7968618f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1162b42a095b3659bb27add7096113bfebf2920c5a80fa08cb468d3c7968618f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1162b42a095b3659bb27add7096113bfebf2920c5a80fa08cb468d3c7968618f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6195990f4fafed5e4e5c29a13e66ef087c71ead8bf6176ac4d1390d24d3ecc3"
    sha256 cellar: :any_skip_relocation, ventura:       "f6195990f4fafed5e4e5c29a13e66ef087c71ead8bf6176ac4d1390d24d3ecc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dd1890281f0e4aa262411c2a08931b87887970a056912cce3c3a631a834739a"
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
