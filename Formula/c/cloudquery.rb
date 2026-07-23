class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.41.0.tar.gz"
  sha256 "0f974938383b61d49c37a7ed54d48884af7e124ce05b589aae24002d27e19328"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e73281c0d38a7daff6d2fb98e985e05d536fa334277c91de8d188f1646a7ce12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e73281c0d38a7daff6d2fb98e985e05d536fa334277c91de8d188f1646a7ce12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e73281c0d38a7daff6d2fb98e985e05d536fa334277c91de8d188f1646a7ce12"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f11a42df4040221a1a0db81b98791811862f9f0013eb4a4505823eb08fc2109"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1d8206e9afb63b89d0e38d487fb543d9bd05d97546995d67212fc2f809ed716"
    sha256 cellar: :any,                 x86_64_linux:  "743b714f00932473edfb3b9b9d7da5cd018c80c16cde8aab1ecbed2c8b9d9e7d"
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
