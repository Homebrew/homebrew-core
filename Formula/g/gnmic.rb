class Gnmic < Formula
  desc "GNMI CLI client and collector"
  homepage "https://gnmic.openconfig.net"
  url "https://github.com/openconfig/gnmic/archive/refs/tags/v0.38.2.tar.gz"
  sha256 "04ef89877680880bf04421196f67f085c35e85d97be97c87c1cf7ff14a0dccaf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ee4c427e0e672cc13e5d65a5112b10a2cbde902a77fc782837cc08c04057e6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ee4c427e0e672cc13e5d65a5112b10a2cbde902a77fc782837cc08c04057e6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ee4c427e0e672cc13e5d65a5112b10a2cbde902a77fc782837cc08c04057e6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "298027c69807f5c41a6002955a80799dd362351b39e6e4ded1c6fb48abb16b34"
    sha256 cellar: :any_skip_relocation, ventura:       "298027c69807f5c41a6002955a80799dd362351b39e6e4ded1c6fb48abb16b34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02c53be85dbd9bcae20dd21dddb97b663ce37167daa018dc13138cb4fa3b50ba"
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
    connection_output = shell_output(bin/"gnmic -u gnmi -p dummy --skip-verify --timeout 1s -a 127.0.0.1:0 " \
                                         "capabilities 2>&1", 1)
    assert_match "target \"127.0.0.1:0\", capabilities request failed", connection_output

    assert_match version.to_s, shell_output("#{bin}/gnmic version")
  end
end
