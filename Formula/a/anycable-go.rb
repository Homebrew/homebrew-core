class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable"
  url "https://github.com/anycable/anycable/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "3d0324493b1c7733b75c2875308771914f99ad7621fa9ad1228323e2497406e1"
  license "MIT"
  head "https://github.com/anycable/anycable.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5b9e19039640c3d2bbb44eda6278ba158b22e47bb0f66c7e26e73dacc74c4cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5b9e19039640c3d2bbb44eda6278ba158b22e47bb0f66c7e26e73dacc74c4cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5b9e19039640c3d2bbb44eda6278ba158b22e47bb0f66c7e26e73dacc74c4cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "94e7201424ccfdbc9e4c74ed5f10eeb48b3a2e14cc6ae57d26fdb2349c3d1d0a"
    sha256 cellar: :any_skip_relocation, ventura:       "94e7201424ccfdbc9e4c74ed5f10eeb48b3a2e14cc6ae57d26fdb2349c3d1d0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07f7d973c6fd613deb6c1a9960d2a2fd7fd158700ba67e8071f77f88cfb750b2"
  end

  depends_on "go" => :build

  def install
    ldflags = %w[
      -s -w
    ]
    ldflags << if build.head?
      "-X github.com/anycable/anycable/utils.sha=#{version.commit}"
    else
      "-X github.com/anycable/anycable/utils.version=#{version}"
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
