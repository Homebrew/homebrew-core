class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.51.0.tar.gz"
  sha256 "77a93d5daaaff73c739bde3c025daeaf27c54c05612fa436cfe3cf3db235f588"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "debda0cb061288cb090a8378375cc1f28017b58f038421dd152d936d6528b37b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "debda0cb061288cb090a8378375cc1f28017b58f038421dd152d936d6528b37b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "debda0cb061288cb090a8378375cc1f28017b58f038421dd152d936d6528b37b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "da18df99abab8f9a9e454fb7fe8028dbb7003236b12ed7812d6dac09fe661a00"
    sha256 cellar: :any,                 x86_64_linux:      "657921dc65b39decd59b1e0abbc2d2b539dbfddd0293801c737c1fa0f8631ea4"
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
