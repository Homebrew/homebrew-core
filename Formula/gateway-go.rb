class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go.git",
      tag:      "v0.2.0",
      revision: "0844398981fcb23bb8a1be0aa61e0b3277fba523"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "189fff1a4f91152cd8721e1540fe96c117fec4742f78c3b68b840d3325175420"
    sha256 cellar: :any_skip_relocation, big_sur:       "ed575679894706f1dfe223c5988cadaf862cfce82137b90e0149536023bfe166"
    sha256 cellar: :any_skip_relocation, catalina:      "87321853027fad8ce4dd0b8bce1900ec4815fc9f3792e9795089acc1a5a68b07"
    sha256 cellar: :any_skip_relocation, mojave:        "26bc78e653b3069a9a84aa95e589d28f41e827a01366e753170eaf09de9f4481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ea26f646a07fd4ad35346d70c0a34e37100d1bd95f24b46105b6f0466a6d3f1"
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
