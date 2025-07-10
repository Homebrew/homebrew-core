class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "52f3d09c7cd710c054c53e3b59e388be6abfa230d2c779b36748c44740bde091"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d14aeb9261a46c16127eff8433541939df9107945a6f41a920c4aff21e8dd9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46f4cd7f61a8499ac83c26507c42370574dea943ae6a7fef273601b8be037cd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0db0aed8de139984c8e683763d32d85e2a75acf5e6a4b642925f5ef452d5d14a"
    sha256 cellar: :any_skip_relocation, sonoma:        "344f5d7cf60299283f412956beb5f0f9acf8651f86c991f35f6e92ae86aab48c"
    sha256 cellar: :any_skip_relocation, ventura:       "4fec5784dc13d968c20ebad6c0c2c28623e377bb0fd342fdea33b69adfa3626c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2dceb5eb02ffcc64f13ceb16c7a2199a83a8d49347bdede3e3cc6ac8a0fe019"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/OpenIoTHub/gateway-go/v2/info.Version=#{version}
      -X github.com/OpenIoTHub/gateway-go/v2/info.Commit=
      -X github.com/OpenIoTHub/gateway-go/v2/info.Date=#{Time.now.iso8601}
      -X github.com/OpenIoTHub/gateway-go/v2/info.BuiltBy=#{tap.user}
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
