class Gnmic < Formula
  desc "GNMI CLI client and collector"
  homepage "https://gnmic.openconfig.net"
  url "https://github.com/openconfig/gnmic/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "ec77ceaeda3f4082df9ec2c83f9bd14036a90d683364f11a70ea7aa2262fe3d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3651b4b4f69c13ba3ff01e13408fbacca0c13e040d86759c802ec2a8730991a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3651b4b4f69c13ba3ff01e13408fbacca0c13e040d86759c802ec2a8730991a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3651b4b4f69c13ba3ff01e13408fbacca0c13e040d86759c802ec2a8730991a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dbf3f87cde6f2861d340dd2ec97815df0300da76c5a331ce532e2a551aea8a6"
    sha256 cellar: :any_skip_relocation, ventura:       "2dbf3f87cde6f2861d340dd2ec97815df0300da76c5a331ce532e2a551aea8a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f417484d3b71604433b8405302590f25db90e0f220384270a8bd00afd569d1ee"
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
