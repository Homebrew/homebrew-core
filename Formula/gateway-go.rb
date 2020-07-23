class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go.git",
      :tag      => "v0.1.82",
      :revision => "00ef621e82242a170181c057244756931607e955"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "59911d2de9cb1d9016b9a8479babe1809898e89824c5889f0e83b80b4276c369" => :catalina
    sha256 "a2e85fa1ceff2b9361f716c177135f6520c5e21b4f51f7f3c04ad18cbb8ee5cf" => :mojave
    sha256 "698be75a61421c6c205b1d1901fb680e477477448bef0365db0e593cec6426dc" => :high_sierra
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
