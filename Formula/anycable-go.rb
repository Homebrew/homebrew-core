class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v1.2.3.tar.gz"
  sha256 "d845c77689ccdf8e42a3ebf09ff1afefe2c65a95186c8d17757eb3a2ae80c5b0"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8240d1e7c2945b393fdc9d07a6a1a6488a0ec412d7940891d6cf3ac11695410c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c674baadfd9c4f7f2f258ff5156c12a5b526d1967441893724cfdc9577468263"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ddf90130aef09d94b6f79df67859bbd910c4bcff66eae284704355557a819b0"
    sha256 cellar: :any_skip_relocation, ventura:        "b1d90868c4d10eb524619f9e0cc7a29fe79aac8c19f192861c12ae74238e9d21"
    sha256 cellar: :any_skip_relocation, monterey:       "fa1c27b5fa3de0355c52c81e9daab4f31a2339b3c319adde56eac880c8cf7a72"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e75bd9d19a0aa0773e2bf88b109fed25c3bac1a6633790c4a7fea88cc55c5bb"
    sha256 cellar: :any_skip_relocation, catalina:       "0ab99bf560e0bef041f27a0cfab51214c4dadc00b192832759261783cf3c24c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95ad0c22819d74ed543ebb832855b1bba511b3630bc68ce5766d03dd6e9a4ce0"
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
