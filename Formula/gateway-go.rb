class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go.git",
      tag:      "v0.2.1",
      revision: "a11b5bb2f7a39846510a82b54b7d7f0cb376c8cc"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a30b9b9d633124d60f8740c95751313cc9c87bb450995ee600f4c681cec48663"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1289511baccbc884e1c79e92e30445a305651485dd2cb1a8b6242ac6b38844ee"
    sha256 cellar: :any_skip_relocation, monterey:       "b96d40dd009bfaa5ecd74824fe860322cf854ec78d9c2abfc9da82d73212d1f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8fce6b06613433741f6a8c2c5bcb9c89afc5498de24c35c89a7a1b4747c4a84"
    sha256 cellar: :any_skip_relocation, catalina:       "7b229dc97e840c50f850831492dd54fe20f1bbf76ab124559a0eedbc58f66847"
    sha256 cellar: :any_skip_relocation, mojave:         "e054ab5529e2bf8dff5537da85d8eb43c550894614e8e59968c235b0b5589b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81394624d4f5bf2a35f565dfa9342f49badf78495b124d0a6ad14103f581050c"
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
