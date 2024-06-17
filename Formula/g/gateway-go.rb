class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "777c064cf4a32ea63fd8e5274b3b6a4099e4ff65fff640150274d0e2421aaf17"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b17f402bea8b82211a57cbe9db4427f3e1af3fc21fde588b0d32da9fc996d31e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e2133fbc71326fd774a15f3ec17598bc97df3520e3b7f47d2e01d67d820d517"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78392b0dbbfafce0e75e014df6f6e0f90c891474e7549e25fb3755f02a44dd8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6bb82a502494368958f3e48f03489e2e72962303581814cfda12ece3c078a29b"
    sha256 cellar: :any_skip_relocation, ventura:        "0fc54d90cbba43554aed3b37d89a5438a2d82ceb838c95882c78195076b9e906"
    sha256 cellar: :any_skip_relocation, monterey:       "826e1bc46b6f807dcba48a347e9dd19bf7bed235a9f53b5a3f74f9d5251623ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa9edd3828e8167cccea458156a09ee0e4fe0054311d1e7af39e73f8146aa074"
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
