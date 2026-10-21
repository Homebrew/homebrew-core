class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.49.0.tar.gz"
  sha256 "9e4f303972a3826cb1d7a9b560d0c41b16f2e144e7089d54a22e1a0f057466e9"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "10ec436ae70e3b35355ad62523f1f6688e73260138c3d9947b49a4f3406eaf60"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "10ec436ae70e3b35355ad62523f1f6688e73260138c3d9947b49a4f3406eaf60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "10ec436ae70e3b35355ad62523f1f6688e73260138c3d9947b49a4f3406eaf60"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b3c3f619fcd2a33d3d72fb3e0458098d7e58db0a736d381c1754de71eeea0686"
    sha256 cellar: :any,                 x86_64_linux:      "934c39fc5adaad48bf6d4d24b100a804d6771181d2ce07c75df62a0fcdfa9c53"
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
