class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable"
  url "https://github.com/anycable/anycable/archive/refs/tags/v1.6.14.tar.gz"
  sha256 "7839edad42090f1a3465b8568d092950a6c77493edca2166b1f6c845fcd68f27"
  license "MIT"
  head "https://github.com/anycable/anycable.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60461d2d482acaa20de367837b5b8f770a73191cbc766c880926a8c8bfa9a9a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60461d2d482acaa20de367837b5b8f770a73191cbc766c880926a8c8bfa9a9a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60461d2d482acaa20de367837b5b8f770a73191cbc766c880926a8c8bfa9a9a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "20a22e86da9b176439231c6c4127914f4dddcc86146e3bba2db7035b48d48faf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34159b2102175855979ab094711738396ecd5b717d0e206544ef168633a77b42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05ea28c69137893592868fcca3ee88335f4d2beba1cb84d0ed2cde735923da7b"
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
    pid = spawn bin/"anycable-go", "--port=#{port}"
    sleep 1
    sleep 2 if OS.mac? && Hardware::CPU.intel?
    output = shell_output("curl -sI http://localhost:#{port}/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
