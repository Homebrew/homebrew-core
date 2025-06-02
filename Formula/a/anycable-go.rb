class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable"
  url "https://github.com/anycable/anycable/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "2f38f8231e3d52873bdfadac7eadcb048dcae48c0d3075a3fd8ce8ac143fd110"
  license "MIT"
  head "https://github.com/anycable/anycable.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b00d0b3bb1c5d9f2978c49de3fc99823d0c6555584cb7d5d88430523bbd751a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b00d0b3bb1c5d9f2978c49de3fc99823d0c6555584cb7d5d88430523bbd751a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b00d0b3bb1c5d9f2978c49de3fc99823d0c6555584cb7d5d88430523bbd751a"
    sha256 cellar: :any_skip_relocation, sonoma:        "15e7fe87e5ca9ab2c65e25a1b8a8fcfb5bbe87f4941feafcfeb432242424c353"
    sha256 cellar: :any_skip_relocation, ventura:       "15e7fe87e5ca9ab2c65e25a1b8a8fcfb5bbe87f4941feafcfeb432242424c353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e67ecdbda60e21d4bd476f8715126f937e5cf9dc529778e6fbd9ce1890997a01"
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
