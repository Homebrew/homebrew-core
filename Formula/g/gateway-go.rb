class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go/archive/refs/tags/v0.3.23.tar.gz"
  sha256 "51e494a8c9ddcb617739815c116aee173fadc6dc1da3f21656242dce8f86a587"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "456506ee402e9bd6c8a82167f87e3c0a179fb8e671442fe06493d6fdebe6eaef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ceeae44cb937e828dbb5d92c613d970732dcdc2611f98d83677ce53e75c7a7eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2f3cf18295b10ae0ddebbebc6c6d10d8253b7b62cc4b4a673a0267c30fb94e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d31fcb30c4b779cbf4eed8c7dc02eb08aa262659b083d7a74245e3f3cbbfd71e"
    sha256 cellar: :any_skip_relocation, ventura:       "e49e2aad60be562014e7e5ac42d313be9cdd153b862834d322318dceb4070c67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec7dfa998cccc84610d3b74bf5d823495642560f230dea3222027b8d8ce75ea5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/OpenIoTHub/gateway-go/info.Version=#{version}
      -X github.com/OpenIoTHub/gateway-go/info.Commit=
      -X github.com/OpenIoTHub/gateway-go/info.Date=#{Time.now.iso8601}
      -X github.com/OpenIoTHub/gateway-go/info.BuiltBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
    (etc/"gateway-go").install "gateway-go.yaml"
  end

  service do
    run [opt_bin/"gateway-go", "-c", etc/"gateway-go.yaml"]
    keep_alive true
    error_log_path var/"log/gateway-go.log"
    log_path var/"log/gateway-go.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gateway-go -v 2>&1")
    assert_match "config created", shell_output("#{bin}/gateway-go init --config=gateway.yml 2>&1")
    assert_path_exists testpath/"gateway.yml"
  end
end
