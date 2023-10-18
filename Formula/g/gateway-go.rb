class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go.git",
      tag:      "v0.2.2",
      revision: "6f0fbb8985fe53ad4dc30410a51e2f3da8ec8c68"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7bce626e1fba08e463ba2976c34a6c3049011635a6c805d42f15f5abc0b42c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c331fdc781e52fdb143bb56c5d2169cfd745890868c4b6a0f0a4e3561b8b74d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c331fdc781e52fdb143bb56c5d2169cfd745890868c4b6a0f0a4e3561b8b74d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c331fdc781e52fdb143bb56c5d2169cfd745890868c4b6a0f0a4e3561b8b74d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9eb9b4ff49e4aac7b782f8d0a765c6d481e7beaf4fb3eeb6952794db6f146a8"
    sha256 cellar: :any_skip_relocation, ventura:        "e60c25daf9f013ce8824dd4461b95568e64ea527e7bbaadec3a896d430059cbb"
    sha256 cellar: :any_skip_relocation, monterey:       "e60c25daf9f013ce8824dd4461b95568e64ea527e7bbaadec3a896d430059cbb"
    sha256 cellar: :any_skip_relocation, big_sur:        "e60c25daf9f013ce8824dd4461b95568e64ea527e7bbaadec3a896d430059cbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93e29bd1f25bd24e2b6cfaa050fd65b127657d6eaedb892505cd0cabeff63073"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]
    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags)
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
