class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "158ec834b4075ec692ac9a761f196f62df7ff2a7d6993eb91d532e89937c1f00"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22a44eb5a97053772ffbc66ad2635f480c671a8c647e6544456a4916d613e3f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "477ecbda042fed5fbd467155825740785d0524a5d49778f8daed3d58d311f166"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9aea14d16b8696c5388d97ff2fc68746397cc39ac5c0a221581dc1df758680c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe9626d7bf272acca18f948668f7fb09226e5445d476526a1b1ca241ea7415c0"
    sha256 cellar: :any_skip_relocation, ventura:        "76643d57dd40eedad61baa58ca602bc23368f3d827a0b0d3b9ec8c0a4b203768"
    sha256 cellar: :any_skip_relocation, monterey:       "6ef885f803e39ea93f5114696429cdb7103abd4ae92f50787449cfc6d724b8ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c28aef6e68b72ab06ccadee031ecf2a7799c26c5ff753f583a2b3c3d7061b7a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=
      -X main.builtBy=homebrew
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
    assert_predicate testpath/"gateway.yml", :exist?
  end
end
