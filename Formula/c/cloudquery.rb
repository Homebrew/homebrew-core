class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.51.1.tar.gz"
  sha256 "08d4d96c04927efe312ca2b8115cc951836122022b641664198c8174176df252"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ae15f21fe72f9d57dc660a02d7b9c016daaeac370ca82209798a7e539f1980a8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ae15f21fe72f9d57dc660a02d7b9c016daaeac370ca82209798a7e539f1980a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ae15f21fe72f9d57dc660a02d7b9c016daaeac370ca82209798a7e539f1980a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "17dbcab28aeb863e308e9b8c85e88fd3b7e7abaa81ed9403ecabda84ee8604c8"
    sha256 cellar: :any,                 x86_64_linux:      "3546aa5c5b002ed8f25842c79a3fc8fb062cc19b7f27e25aeef7cdd9b8901447"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download", "-C", "cli"
  end

  def install
    cd "cli" do
      ldflags = "-X github.com/cloudquery/cloudquery/cli/v6/cmd.Version=#{version}"
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
