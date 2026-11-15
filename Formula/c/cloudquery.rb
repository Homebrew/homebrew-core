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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e8633a3e808600f70f31f3ba97ab1fc0b502d6debe06f047165c60ef10abdbd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3e8633a3e808600f70f31f3ba97ab1fc0b502d6debe06f047165c60ef10abdbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3e8633a3e808600f70f31f3ba97ab1fc0b502d6debe06f047165c60ef10abdbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "90f521d38e1bf8f5a9d26948a90fcb8f072484c7eaa90875c14f7f1b85f7891a"
    sha256 cellar: :any,                 x86_64_linux:      "d34bbb4af4b4ade02c09b93d05d4ba0338fd7eac7fef54469d39ff7c12f6c0a7"
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
