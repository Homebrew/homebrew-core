class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go.git",
      tag:      "v0.1.91",
      revision: "8df96b8ae676344c14277c61ee8ac8bb206d8ef9"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "10ff0cba67441b81dd8413d567b753a0ae7723c64404fbf093deaa88ac079bff" => :catalina
    sha256 "853330c62b69d05d75eff2d186b720811c3c2dffb5e777501855ba48b47e1e66" => :mojave
    sha256 "3a876c3cac9f3d4d239d2d0718c0d71c888e06c65854d1882c00f461c8c86ac2" => :high_sierra
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
