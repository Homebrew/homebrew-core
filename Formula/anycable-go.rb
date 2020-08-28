class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v1.0.0.tar.gz"
  sha256 "66c6039ad96433cb0a4851f30c917050a1062d269594259bb1665ee03c23e7e9"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git"

  livecheck do
    url "https://github.com/anycable/anycable-go/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "158a7e9917bcdc099b664996e081dd2b020d2036a22e92f351bc9df43a33995d" => :catalina
    sha256 "698707ba2032a713055be8a35b6c8ea2baa3df3d90502ac2458996150940716f" => :mojave
    sha256 "d16176f21d70123a5c709b1a69214acdeb2825dfd50d038e8db815afe62d6a11" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %w[
      -s -w
    ]
    ldflags << if build.head?
      "-X github.com/anycable/anycable-go/utils.sha=#{version.commit}"
    else
      "-X github.com/anycable/anycable-go/utils.version=#{version}"
    end

    system "go", "build", "-mod=vendor", "-ldflags", ldflags.join(" "), *std_go_args,
                          "-v", "github.com/anycable/anycable-go/cmd/anycable-go"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/anycable-go --port=#{port}"
    end
    sleep 1
    output = shell_output("curl -sI http://localhost:#{port}/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
