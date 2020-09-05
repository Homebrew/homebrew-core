class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go.git",
      tag:      "v0.1.90",
      revision: "e4de8d714c3899f70c75550e81841b8246c8d08e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "5263c644db3dec3a9163ffcc71b1f99c75730ba1275a8a9bc2affcb6ef479f59" => :catalina
    sha256 "74351f8be7f640eba1a1742938539db1d8be37b9f2e63dae58a55e7d387a7e9b" => :mojave
    sha256 "6038aee8b37e90dc5582c000d8fa1845ccab252190c22cbf6af8a472fb55a14d" => :high_sierra
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
