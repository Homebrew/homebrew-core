class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.20.5.tar.gz"
  sha256 "29939d99b09d182a06ae3359b9b1e6c67b4bdd1eeeac790698481fd1d3e8b291"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43b3f5a021785ebd78a44cbc28efb18b2dc485c43e0ecf352f2e05325b6ed9dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43b3f5a021785ebd78a44cbc28efb18b2dc485c43e0ecf352f2e05325b6ed9dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43b3f5a021785ebd78a44cbc28efb18b2dc485c43e0ecf352f2e05325b6ed9dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "908b69eb7f6458fe793f89aff6c3225eb89f916dbd9db51008a639407f7550a7"
    sha256 cellar: :any_skip_relocation, ventura:       "908b69eb7f6458fe793f89aff6c3225eb89f916dbd9db51008a639407f7550a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8ebda75a66507bac99074bd96f1a1c88b4db004af858dd480b631d347791f9a"
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
