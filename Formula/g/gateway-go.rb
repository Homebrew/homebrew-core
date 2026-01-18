class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go/archive/refs/tags/v2.0.12.tar.gz"
  sha256 "b06175c5c5ee602ca1a2c4652033c865a12e226eee7adfefb0dde807a3c5ff63"
  license "MIT"
  head "https://github.com/OpenIoTHub/gateway-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f75ffdf01910d42ba4414beb0c093ce7cb20f305c7409f2e9b329949bdd19bbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ed644b847ee7f2626fe8f017d4e95b9be6e2d644c4ab04d02f5da16c5cd2dad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36b71b06b0647849bde0330e0927b965f898565c52d3a192cbc426d98746202a"
    sha256 cellar: :any_skip_relocation, sonoma:        "99cde3cd4107a5c0b13f6eca935df9fbc2bbb7dfb0b40b3c92f0b47cfbb33f42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ad72f55a82ffd324c334b6fcc428c0d1d650ebfe4078b76de451339c8b9d89d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c02836cc5373617ea8332bd360e9a727db388e29a981337eac7087cbd1eeb712"
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
