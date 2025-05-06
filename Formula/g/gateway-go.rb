class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go/archive/refs/tags/v0.3.20.tar.gz"
  sha256 "c813c7054eb495451f55200a2f9e35817144d11953b1bcef0aeb2ada0185c469"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd7bb0bbfe98f11c8c808a9df2694a4e228c13111107a6ad73b7bbf2c9c3bf20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c2c34966d71beffff420235ad7a1d99a899b927cb5cb85e3d0a1e75ad5c9e8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd7bb0bbfe98f11c8c808a9df2694a4e228c13111107a6ad73b7bbf2c9c3bf20"
    sha256 cellar: :any_skip_relocation, sonoma:        "cafc14744e603d10418fd53124d33e3e8b3d80c66e1d66a2abf8b8f202580622"
    sha256 cellar: :any_skip_relocation, ventura:       "77977104153cd170f005bf4a5779a2458ab191008395241753f277cf19c6ec0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51d8614b9639580e365b35d38ddaa35836ef3559efed0db3df10145af863d6e2"
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
