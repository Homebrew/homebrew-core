class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.97.0.tar.gz"
  sha256 "432ff2dde385163e52661415368f5ffb474ee30385e4cea111676c80258449dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d3707f511856279d650cc839b27b883f9ef5201e06f5f48f33be81f910659063"
    sha256 cellar: :any_skip_relocation, big_sur:       "893a65234005a2fc23d29c1c89c6b26a074caf9c0e2a5709d40e23534b388a78"
    sha256 cellar: :any_skip_relocation, catalina:      "2bdbc753fbf37b9812b115c7e5215032feb1a5084df148644744eedda4bc7be7"
    sha256 cellar: :any_skip_relocation, mojave:        "67521cd0b324a9cb87b21e6caacf3d36bd9bfe9f0f2a489681172a6e62e14054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b25a85b14e884cab3cfc267bfa26ef8290bd76c55350365f570563b1c63776f7"
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
