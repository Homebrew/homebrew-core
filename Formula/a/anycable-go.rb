class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable"
  url "https://github.com/anycable/anycable/archive/refs/tags/v1.6.7.tar.gz"
  sha256 "49e2854ef16cdbf9d4924f58b93492c6636c9680a35be76b61980ed4c7145fcc"
  license "MIT"
  head "https://github.com/anycable/anycable.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "495402ba78e7c05e2d8fac59535b9f9bcfea0258cdd4ae47c5a1ab2b02125a3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "495402ba78e7c05e2d8fac59535b9f9bcfea0258cdd4ae47c5a1ab2b02125a3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "495402ba78e7c05e2d8fac59535b9f9bcfea0258cdd4ae47c5a1ab2b02125a3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c260db3bc981f577f66b43fe94d110e95257bb90e5e6a6abd21fdf499335f3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00c12ea2802b26c3968353009da6c528da6f74ef2baa2eb98bfa4c14fdbf3d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6715cf082744317effe0513ec64761b74a57cff45f487b7775460aa2b5cfecc"
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
    sleep 2 if OS.mac? && Hardware::CPU.intel?
    output = shell_output("curl -sI http://localhost:#{port}/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
