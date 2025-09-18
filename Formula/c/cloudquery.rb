class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.29.0.tar.gz"
  sha256 "4a98e73f11ec3c3fd4bd4d78c4a50a876fbf74c40410a611c70df7b8b15306cc"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a29eb81bd9f5b84a45dab9f8096b6102b085004232b5dde4af40c1e39a7ffe0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a29eb81bd9f5b84a45dab9f8096b6102b085004232b5dde4af40c1e39a7ffe0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a29eb81bd9f5b84a45dab9f8096b6102b085004232b5dde4af40c1e39a7ffe0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cd21a3dc05a3882e4831ee9d69f9c213643971993dff788d0c99c59e040f0eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e6c1fc0f8a8db6f05796225c36d59cb6f408d12f3a9d34e5932d77ed3d35bdb"
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
