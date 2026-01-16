class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.34.0.tar.gz"
  sha256 "90b1c3e8086b81ebf36b89044091d8b231e3d18b26a2a93274bd6818274da19d"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2d49a89a15427af685ce68182f77c1957147cf4f1525a1e866d273e5600c29c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2d49a89a15427af685ce68182f77c1957147cf4f1525a1e866d273e5600c29c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2d49a89a15427af685ce68182f77c1957147cf4f1525a1e866d273e5600c29c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9c4038331813d6fa3ee09cd46567d5efdcd29b6f7cd59643cdc4f78dda477f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a1aea005250ea4453ec2c74f0136ee3101554a22cb84869a3ecaedac9a3cde4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dda560dd1b37ef5ad921ac0c5530dc2fa8d84d101eac3a3ac44ca6198c6e0d31"
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
