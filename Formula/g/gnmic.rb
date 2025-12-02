class Gnmic < Formula
  desc "GNMI CLI client and collector"
  homepage "https://gnmic.openconfig.net"
  url "https://github.com/openconfig/gnmic/archive/refs/tags/v0.42.1.tar.gz"
  sha256 "75485febc0d7548da6b91d0918407213d270c47e8babe4a303abe635f34d8b12"
  license "Apache-2.0"
  head "https://github.com/openconfig/gnmic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dce3ed3a882f5c074c33a28fb7f91ba4ea77b20047dcd60f87db937550d8858"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d081bb4854f6ec0e8038461c162a5cfdcab4bf485b5d473d8430eb4c6e05aec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53a33667c4300ecce03e90d38c7fd510368fad8f491b0fcae9c83c8e6475c415"
    sha256 cellar: :any_skip_relocation, sonoma:        "f95ae07eec0ebaf555f04a2e1fc8192bd48ffd8f3a3e3b40590800ec04540339"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "251a8908746be58cee6dcf125c280acb435382267acf18e88149fc7c6d85599f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59f1c4e57bb823731015765ddb3a1aa3c70e002c5e5aa1c14e8e9ba682f93b17"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openconfig/gnmic/pkg/app.version=#{version}
      -X github.com/openconfig/gnmic/pkg/app.commit=#{tap.user}
      -X github.com/openconfig/gnmic/pkg/app.date=#{time.iso8601}
      -X github.com/openconfig/gnmic/pkg/app.gitURL=https://github.com/openconfig/gnmic
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gnmic", "completion")
  end

  test do
    connection_output = shell_output("#{bin}/gnmic -u gnmi -p dummy --skip-verify \
                                     --timeout 1s -a 127.0.0.1:0 capabilities 2>&1", 1)
    assert_match "target \"127.0.0.1:0\", capabilities request failed", connection_output

    assert_match version.to_s, shell_output("#{bin}/gnmic version")
  end
end
