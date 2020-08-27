class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go.git",
      tag:      "v0.1.86",
      revision: "41021108b389f47646a74379439853ee4447797c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b7bf2719a4ff53b18b34299676ff6922ad197acf4d9b8e8e36354b44e59681d" => :catalina
    sha256 "dbad229c58f27b9391ce8b8669344f94949299131c871bf2562e709801391e3c" => :mojave
    sha256 "83ce4a71613655910ffdaa775a35c9cb2e7da7774e2bd7628300e5fcd0d18510" => :high_sierra
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
