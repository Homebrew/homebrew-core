class Gnmic < Formula
  desc "GNMI CLI client and collector"
  homepage "https://gnmic.openconfig.net"
  url "https://github.com/openconfig/gnmic/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "4d3488bdcd49e38249d52e299724cb981fb4266258b931a78cc026be952650dc"
  license "Apache-2.0"
  head "https://github.com/openconfig/gnmic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb844704d1792a9bbc064e45d08161664f336d1adced43ed586c20e3db959148"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d18070ea49922eac2566afac8b74076c5ed8b026d0bb5d2a21b1fc5c80bce456"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ffdb5e94464aace6b7f78002da311ee8ef3bc5de4e8ec5621cd06f4d4618e1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "969c81b20b71c0739cedd234b5b7a591556682a8f8a8ea85cfa89afe043135b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6bc581bbc18bcc1e4cc4d4d2bb2d19307478fb32a97a1ade73c0d366dadddda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "759a2b2db33ba1af3c0f05732f303740028b4ccc5341c6b2afc1985f92473b45"
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
