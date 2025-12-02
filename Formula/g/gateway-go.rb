class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go/archive/refs/tags/v2.0.11.tar.gz"
  sha256 "8e6eb66bbc95a22bfa09c25cf55e20a803cda64c8e38c4fc8d01389cb6c20581"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db8344f11e99cc6b59e7d04c52f767a25fe19b1baa9bf3619527281a87282e8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "432159ef7f4efaad41c272483803834c97a5e2da4324999d2d5bb8e84190283d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73153cdeb9af0633d107a707bd4380ed45510be96f0f580623dc1a673746a164"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2fee6e26ef52c684f07404f43b28cca3d6c98c7e2eb77c05778e71a0892be54"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea1f7e04b61873ecc112c7a780d9f6865a0361b48bdd4ba4ee88544fa7bf898b"
    sha256 cellar: :any_skip_relocation, ventura:       "b908b6d560ba03720d79b9346d86966f62b0bfb54dc849013224ab08463aa4fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75f39c500b0df9aa0e7a6edc132e0989784cb70589ee49f38f88462a835b96cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "574a9244c32bf65a8bf49a14573b4911ce71cfaf344a3efadbad65833d5ba854"
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
