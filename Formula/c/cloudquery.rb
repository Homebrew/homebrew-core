class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.42.3.tar.gz"
  sha256 "4c29d87dfa78bda9b6fd06789ffdd37f100e9b95b55e370b02c3d68d20250bb1"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ad5892a0fcda57d820cd163e95595aa75b3513fd8438ce951846b242433ad7ab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ad5892a0fcda57d820cd163e95595aa75b3513fd8438ce951846b242433ad7ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ad5892a0fcda57d820cd163e95595aa75b3513fd8438ce951846b242433ad7ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "005f608c2bdbfa82b593232e0de4f5f44b05553280f1d17f6b024a095f26fca3"
    sha256 cellar: :any,                 x86_64_linux:      "69dccde4eba8eb469d8036c38328f97971726208f29f0da4fcaf2331e836d614"
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
