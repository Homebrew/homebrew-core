class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.15.1.tar.gz"
  sha256 "fb28d7017442771288a6f55ef2283663fbf28f3329d258178fe5b8366c931bf8"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d447d1f06b0bd834ec3046a7e331b173ceef39d92e21d72cc6b4f5328496047"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d447d1f06b0bd834ec3046a7e331b173ceef39d92e21d72cc6b4f5328496047"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d447d1f06b0bd834ec3046a7e331b173ceef39d92e21d72cc6b4f5328496047"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f04746b60acc494c3cde752aae6a2a95a22b70981bde859225cfae2ce0f2a31"
    sha256 cellar: :any_skip_relocation, ventura:       "8f04746b60acc494c3cde752aae6a2a95a22b70981bde859225cfae2ce0f2a31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eb25dd1ec4a06b514a63f065af406f851162eea1b8f0fc5c959c536d9b9a903"
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
