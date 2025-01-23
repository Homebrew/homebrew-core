class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "77001d6db5019a292db7b2f81fa005fed77316872859879b03f27a76247b1a6d"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "64aad01698044023d65cf68e331110384832a43675bae1181b3f4ad5f07315ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abec10f08360554d2f79ab0559b887304029069b5c36a30c7c56159819d086f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abec10f08360554d2f79ab0559b887304029069b5c36a30c7c56159819d086f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abec10f08360554d2f79ab0559b887304029069b5c36a30c7c56159819d086f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "393ebb53edf3423fe6e3e8c487838a3fc5cde4953d004453a1b731b499831967"
    sha256 cellar: :any_skip_relocation, ventura:        "393ebb53edf3423fe6e3e8c487838a3fc5cde4953d004453a1b731b499831967"
    sha256 cellar: :any_skip_relocation, monterey:       "393ebb53edf3423fe6e3e8c487838a3fc5cde4953d004453a1b731b499831967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a802cbc78f87b2198602c52977e393bb8fb997774575c35aed49917a474526b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=
      -X main.builtBy=homebrew
    ]
    system "go", "build", *std_go_args(ldflags:)
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
