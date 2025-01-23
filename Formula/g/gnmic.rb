class Gnmic < Formula
  desc "GNMI CLI client and collector"
  homepage "https://gnmic.openconfig.net"
  url "https://github.com/openconfig/gnmic/archive/refs/tags/v0.39.1.tar.gz"
  sha256 "beaa239bfb02d907e13f07fecfc4329730319965adbb1a24106e7b42f60a67b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68711dfb00bbc487f277bcf2527a0b64f75cee80a05f002305f79bc36670d109"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68711dfb00bbc487f277bcf2527a0b64f75cee80a05f002305f79bc36670d109"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68711dfb00bbc487f277bcf2527a0b64f75cee80a05f002305f79bc36670d109"
    sha256 cellar: :any_skip_relocation, sonoma:        "059b74fd5ec7bf50a210781650e30fc00c7e50581b3bd82e3a87f9b52e19fcd2"
    sha256 cellar: :any_skip_relocation, ventura:       "059b74fd5ec7bf50a210781650e30fc00c7e50581b3bd82e3a87f9b52e19fcd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ba9ae17f1994b7b1cb0055a876078485f0c859f0d69a1e201d69cb5d28794ef"
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
