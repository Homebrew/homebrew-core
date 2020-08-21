class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go.git",
      tag:      "v0.1.83",
      revision: "b5b4f2349e7352b2370ead591f2b730f2994fa9f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5bac4bcf5bd28f4c36d9703889cda22a610db6173cf14df84df4ad50c28a349" => :catalina
    sha256 "fd65ce14d2bd366507e04856d444c53c06e251c58f5efb19b9e9270416ea35d8" => :mojave
    sha256 "8efa48f8a85545308d5fd49085ab56f9c14734303015226f76e6162339bb58e4" => :high_sierra
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
