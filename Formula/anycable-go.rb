class AnycableGo < Formula
  desc "Anycable Go WebSocket Server"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v1.0.0.tar.gz"
  sha256 "66c6039ad96433cb0a4851f30c917050a1062d269594259bb1665ee03c23e7e9"
  head "https://github.com/anycable/anycable-go.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4bd9d4f3702cb24aa1d4d3e771e9646eb9afb6579d3a0392b5d96193636e06ac" => :catalina
    sha256 "c682c175323bf559a06aefe02c0382f8b2ba8efdede367ccc876cd4287b42fee" => :mojave
    sha256 "8221be54a2ae4a1ca0d3b5bb6821d7dc3217e6f41bf25ee8716b93f2d5e002ce" => :high_sierra
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
