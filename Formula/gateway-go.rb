class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go.git",
      tag:      "v0.1.84",
      revision: "02671c3c79f0eb2e9b665ed8d80d3ceb0481a438"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "467620033d88fd9ee027307ee3feaf160c96cc86859a3157a8d8c2e6797e6f4e" => :catalina
    sha256 "443ae643c46bc5f24a1dbe4d570adbee95726f0f8802b0543906857a98bf30e6" => :mojave
    sha256 "36a620caa3011349c5c422e0c0443d2711703586048cc8cac3b1fc6ff263c688" => :high_sierra
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
