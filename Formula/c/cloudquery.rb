class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.35.7.tar.gz"
  sha256 "c718ad6a7c1d9ddd3395c2a7145183b11b7d93b2dad789d4b18f0cd5bd77b488"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f909b0620809a23cfa669fad2d0d73922b5af86e9f32e08ed51cc8cb02acb7c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f909b0620809a23cfa669fad2d0d73922b5af86e9f32e08ed51cc8cb02acb7c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f909b0620809a23cfa669fad2d0d73922b5af86e9f32e08ed51cc8cb02acb7c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9aa089d10834a95f9fa10e2718d0e7780df702cfad47fea6d689e5dc5f2cb584"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c202d98cd867710b5a1ea69895c67f4b1c8137d21bc27c9650777f0c7da85cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f16979f8ddd4d9893d32699714ea8fc964b0405398ecd425716d80253ebf6ae5"
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
