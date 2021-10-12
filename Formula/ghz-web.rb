class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.105.0.tar.gz"
  sha256 "c2c257dcdf708e742ff80cd5a1b205991c9192cf857cafc90ed4be8ff2097ee1"
  license "Apache-2.0"

  livecheck do
    formula "ghz"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4ba20774138482d7d44a88f4006242b2ab55fddaf2958b7a7fb87b353cf5da4b"
    sha256 cellar: :any_skip_relocation, big_sur:       "f57fd218387fc28aa8617fd3941d39c8b127a1bfd5a6d2a661b7d46dd319e821"
    sha256 cellar: :any_skip_relocation, catalina:      "e70516a651dc361154117d2e6f4030ab76db89674ffc788cd3f9b277b82482d1"
    sha256 cellar: :any_skip_relocation, mojave:        "5f4720b5ba9b253102d6e0832751e7916a795dbcdc435c6efc48fe06ff2867f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee6c808f8b5c48c3d2010c45d6d77e2d84dd49d563f6e70afe61f9f83a176b36"
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
