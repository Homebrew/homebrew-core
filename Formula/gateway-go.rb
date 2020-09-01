class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go.git",
      tag:      "v0.1.87",
      revision: "471662da313928f475ff6836e5b78227fbec1050"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b352aca114d535e64227a6b860e228a44c811e3d5fc9cc91d684d9d2e46680f" => :catalina
    sha256 "1586ce54282f3cd2861ca1509b8313cb3b927a30dedecead6963f2653f1f6e1a" => :mojave
    sha256 "7aed612144587fa557e1918529cbf152dd6710c505fa00be596cc53458833477" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gateway-go -v 2>&1")
    assert_match "config created", shell_output("#{bin}/gateway-go init --config=gateway.yml 2>&1")
    assert_predicate testpath/"gateway.yml", :exist?
  end
end
