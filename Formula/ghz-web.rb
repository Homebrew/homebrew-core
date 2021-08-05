class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.97.0.tar.gz"
  sha256 "432ff2dde385163e52661415368f5ffb474ee30385e4cea111676c80258449dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "db6cd5c4acad45ca385fbfd9794d2bd2252cb486b1ea762bd3d3c54fa1b9c87c"
    sha256 cellar: :any_skip_relocation, big_sur:       "93f3910033502be9b5111d9cf2a24bb31bad60b157715da98b58c02aee00c03e"
    sha256 cellar: :any_skip_relocation, catalina:      "4a7f91a6d93a14512e3b616a57aae7f65f5392c781829d695f814f9f9a38a747"
    sha256 cellar: :any_skip_relocation, mojave:        "a3ed211fd020c5feaf6269c342027f0ca9b3d8b40100316e82a7af373478ac4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9e54322a3f07231655cfd1ccfe58b78f3a435cbd2214223896921795ccd65d8"
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
