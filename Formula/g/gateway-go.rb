class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "52f3d09c7cd710c054c53e3b59e388be6abfa230d2c779b36748c44740bde091"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7836b89804bd4c92f46d5f882275fafeb189bba07015e066ea59e306d087944e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f4bd996faab8bcfe1911534833f09db4f6b8296648fe3d9a70c2f1f9191d5aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dddd896b5bbf09b1f87bddf84b09527605c7bec768ab8ef4c2103670a84a30e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "531a5bf21184318f3e6a243049f7ebd3caff1950ff2b1d55224ccffdf3d5e893"
    sha256 cellar: :any_skip_relocation, ventura:       "39758b120d433e093fcbf464013eb90a1cf97e0cd30dbb46ada68687216b0a9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bc17f89c7d4d1ba20af1bb55523296df2da42d661723e3429048783aa376562"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/OpenIoTHub/gateway-go/v2/info.Version=#{version}
      -X github.com/OpenIoTHub/gateway-go/v2/info.Commit=
      -X github.com/OpenIoTHub/gateway-go/v2/info.Date=#{Time.now.iso8601}
      -X github.com/OpenIoTHub/gateway-go/v2/info.BuiltBy=#{tap.user}
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
    assert_path_exists testpath/"gateway.yml"
  end
end
