class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.104.0.tar.gz"
  sha256 "045b2e0194f46bc610fe220d5eb953987c5d9f0a6ff2c59cc642803aaf589256"
  license "Apache-2.0"

  livecheck do
    formula "ghz"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fd83ba6f5457a0f7fd16caf9668181b5d08867f37fc80090492287ec3495332c"
    sha256 cellar: :any_skip_relocation, big_sur:       "0865f25d254cfdfa50d0170afbd76dc1276314f5d99610c8693ab7cf35f65035"
    sha256 cellar: :any_skip_relocation, catalina:      "da34a4440fddbc8f471e1a00b5c4a53bb3aba8cfaaca4c4c5c85d46cbb9445c0"
    sha256 cellar: :any_skip_relocation, mojave:        "323171d3f2f6b66c44cd725120958ae142d0a2f8f38bd143f788c0801abf4d4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d6b8604172cbfa1c5524c79cd9cea471c57cd1fca153a7489b26d61089c88c0"
  end

  depends_on "go" => :build
  depends_on xcode: :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      *std_go_args,
      "cmd/ghz-web/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz-web -v 2>&1")
    port = free_port
    ENV["GHZ_SERVER_PORT"] = port.to_s
    fork do
      exec "#{bin}/ghz-web"
    end
    sleep 1
    cmd = "curl -sIm3 -XGET http://localhost:#{port}/"
    assert_match "200 OK", shell_output(cmd)
  end
end
