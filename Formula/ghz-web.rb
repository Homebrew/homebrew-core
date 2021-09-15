class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.102.0.tar.gz"
  sha256 "b02442f351058d95d48b2166306d7279b6e42b9038823ea1ce75eae24f641f11"
  license "Apache-2.0"

  livecheck do
    formula "ghz"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2f1162a31f8d65dcf2addf320d62e3c2317d98b6aa611368058910898ad54e91"
    sha256 cellar: :any_skip_relocation, big_sur:       "c9f32a404fb3a0a135a45204c5b87b4627008baf65f428c52594fbf5390c3fdd"
    sha256 cellar: :any_skip_relocation, catalina:      "308171239ac103f2fa6031ed2076cf780a8169b6ff9df5b0031f1f8edcc1efc6"
    sha256 cellar: :any_skip_relocation, mojave:        "1f39541211ef22e24e1ed3b363357cf404a66f610e963a5cca9586e8fbd3d7ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d47f31c8640209dca4fd6df70c72a39b5a55123fca5db496813a023b4e59424b"
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
