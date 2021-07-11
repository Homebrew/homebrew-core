class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go.git",
      tag:      "v0.1.98",
      revision: "ea71266326832f4f17a9d1219e5e19781a5bfe8a"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "68a83d86168de5770073aade23a9eca36f7c45af46ebaea6bf467caf08bd6161"
    sha256 cellar: :any_skip_relocation, big_sur:       "31a5cc63190a8e757c9a7ec84f4ed0b3ba0252d3ee479ee795d3a9fd3c622257"
    sha256 cellar: :any_skip_relocation, catalina:      "31d0a5a6767e70634c0c2b3d077c0de1533ff4655a1cf14e933cedfdc3e0f993"
    sha256 cellar: :any_skip_relocation, mojave:        "81a1ec5d087317840427958e1a77ce1a8dfd492864f427a624e4a980d9e2b85d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a45fab4aebb7fdd380d0c022ebcca61a605344e38b368e1a53a3dd4b6ae3db9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]
    system "go", "build", "-mod=vendor", "-ldflags", ldflags.join(" "), *std_go_args
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
