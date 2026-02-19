class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable"
  url "https://github.com/anycable/anycable/archive/refs/tags/v1.6.9.tar.gz"
  sha256 "703bb0941b3f4a104b8c4281569f955c6313ab872ec5797096aab0d6bd1bcf81"
  license "MIT"
  head "https://github.com/anycable/anycable.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b554da43956ef69ea584a906bff428351e37f038781f702b778a2dfb1fa4d644"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b554da43956ef69ea584a906bff428351e37f038781f702b778a2dfb1fa4d644"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b554da43956ef69ea584a906bff428351e37f038781f702b778a2dfb1fa4d644"
    sha256 cellar: :any_skip_relocation, sonoma:        "41237903282b7c872819eceecff7cc6575acb58cc2df443f59759d5415feb1ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e91f4af987a0083cf065e08eb99058886c53d16303747c3c6cfae1efd788a7ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12bd734e2e42306a2bc08e3dbe92298e9b31cf270db5d935158074996c32ced2"
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
