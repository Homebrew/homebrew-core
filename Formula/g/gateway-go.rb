class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go/archive/refs/tags/v0.3.18.tar.gz"
  sha256 "8b679df2600a6fca097b6ece84a825c4d0586e2b66d853a9cc4d58fabc474395"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c7855b3a83ed76363e05a260cdcf57ae9db30b2cb65f5d82b2bc2d0645c4149"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be4e2122ad85552a7f41c845e1b06c34ce440b13c9bee5c0a27c9d900e01bddb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52da06ab1cc1c773859b65b8bc205866eb0046b7cba48034538cb005d54eaa73"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea30696c5e66419e0cacf0efa110bcd8011be9dab271e4a53b192061b960f4ba"
    sha256 cellar: :any_skip_relocation, ventura:       "22fb81947598bdfde54db43c5736dd7c6ee367528bae33a97b88151c6f8ba84c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22446bdb108cedea9b9e03cc6f7e50cac3a9ca55759afd88b0e7787dff4629b3"
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
