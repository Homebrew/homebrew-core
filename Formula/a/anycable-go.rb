class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/refs/tags/v1.5.6.tar.gz"
  sha256 "ac590a7072cd9048e588a1e9eada94d54e97f495f4a6986f2ade912581600aac"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5780d2d0a7b42e61e4b4088e15501cafe6650094f1e7654c9e8096756681f980"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5780d2d0a7b42e61e4b4088e15501cafe6650094f1e7654c9e8096756681f980"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5780d2d0a7b42e61e4b4088e15501cafe6650094f1e7654c9e8096756681f980"
    sha256 cellar: :any_skip_relocation, sonoma:        "61eefac6d3275973dc3897f9fe0b3bb9ce4b3267d372b9bceddefb5a739fe2dc"
    sha256 cellar: :any_skip_relocation, ventura:       "61eefac6d3275973dc3897f9fe0b3bb9ce4b3267d372b9bceddefb5a739fe2dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9635b139870b57d2d6f3aa3eff50469c05cdabf1b3a7299e1552fad03f5a977"
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

    system "go", "build", *std_go_args(ldflags:), "./cmd/anycable-go"
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
