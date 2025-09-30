class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.29.5.tar.gz"
  sha256 "d6021eff7b361c34218e38a4b4cc7379f4000f18872dc3af519e24e27d12852e"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e263d7f2a346bb3f4f1a2a609e4dc2cf14dbc99d8bafbbd2985447e671f39974"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e263d7f2a346bb3f4f1a2a609e4dc2cf14dbc99d8bafbbd2985447e671f39974"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e263d7f2a346bb3f4f1a2a609e4dc2cf14dbc99d8bafbbd2985447e671f39974"
    sha256 cellar: :any_skip_relocation, sonoma:        "256f3e68174d9864c799797f2bf178fa270910541e5a4d9394a134c9acb3de18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3162db64e29cbce728de834d452ed4d05d4a57e73fa909358a21b71d15ce2425"
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
