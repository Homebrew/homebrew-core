class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go.git",
      tag:      "v0.2.1",
      revision: "a11b5bb2f7a39846510a82b54b7d7f0cb376c8cc"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3f8e86394e60af211b25a22b4335c6b9798662bcbf726beb6af4be85b7b3d654"
    sha256 cellar: :any_skip_relocation, big_sur:       "de5591fc8b3ec4a8ed2d1685e5d852c6b47997c055a136cc481a2cb1942e3ec6"
    sha256 cellar: :any_skip_relocation, catalina:      "7d43b3c252fbd94a9384f95a61941555680d7305f3cd0caf6faeb90cc1096c1e"
    sha256 cellar: :any_skip_relocation, mojave:        "732509e3d38e1c540d0e4faf5ff95524a38626eefd240d73e4878d743fe9e071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0e22eb5a6edfc6ff20d2104fccc8b5c0f50720a1fbb647a6bf0cabea1773ae7"
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
