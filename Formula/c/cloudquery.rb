class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.29.7.tar.gz"
  sha256 "6b847a6b4e1ab3bc0ec3ec093dc841550919ec6de3009ccb54035303aafd1d67"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ef9799d0c5333ea1f6de7bbee16a4d5ebd60ad3a663665c8e3b47dd3b19ebaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ef9799d0c5333ea1f6de7bbee16a4d5ebd60ad3a663665c8e3b47dd3b19ebaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ef9799d0c5333ea1f6de7bbee16a4d5ebd60ad3a663665c8e3b47dd3b19ebaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "ced1c09ec3d0b85ba0435bdaf70d2ca0406e0ce351aade05b627134a2440f48a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b733ba14a5ef9f133c3eb15aab0f4bb304f81d61b24c5727db5ce0de292c8cc3"
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
