class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v1.2.2.tar.gz"
  sha256 "2095e8aceff1d91bce8c55f990d7aa69dedab3d5b1e5c89900ea50b644d9d0ad"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1a537eca1a84bfda187e07624facee71d445c583ee69e10461416d6d7d4cf05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "704866ce19dd38cbf29aa0e571765d5f1e9540fa3112188473e5746f1df56ac4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6e6e8ecfa3d010fe5d70183fdf18ddc99e118072906f2fa1943053f00692a9c"
    sha256 cellar: :any_skip_relocation, monterey:       "363023b6548d694249780698d1fe6afa6711ebcbd4ff1fec9edbb37f59e03f24"
    sha256 cellar: :any_skip_relocation, big_sur:        "654db2fddc1dc6a799ea5a77c6b54bce3907d4d8aae6c6a3309f0efab3e3b506"
    sha256 cellar: :any_skip_relocation, catalina:       "439ba414f0063702c100b18886f88276cbbae7cc4638800ce93aa8d8b550c777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d79e580e996dd3268235e5c6ba611d8fe365f38731d3e8e13bffecd538eec1d7"
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

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/anycable-go"
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
