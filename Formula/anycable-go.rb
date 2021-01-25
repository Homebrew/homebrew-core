class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v1.0.3.tar.gz"
  sha256 "8aa780b0ee5bf527fe211585aba2441a9cd5b72e58f353e3d4f76286262bf33a"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4fad3cde32a0582f7c67e5b1c1cf042b26440550adbea601b8e47a8391628763" => :big_sur
    sha256 "ee40011c6d573f3f567adeec8098428d602580fec188af1191027380b0017989" => :arm64_big_sur
    sha256 "c9524a91cef04b327a268ed84a95bde54adaf82b82527bb3e086382c81fc6798" => :catalina
    sha256 "3ca5d2a4a546fda4da5e840ef21f80494bcc0fd1df3890040cb63fcfc59911eb" => :mojave
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
