class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://anycable.io"
  url "https://github.com/anycable/anycable/archive/refs/tags/v1.6.16.tar.gz"
  sha256 "de56090640a0a5a14efb4726551afb9e4eea32b72f220195cb476180e544ee6f"
  license "MIT"
  head "https://github.com/anycable/anycable.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "483f37b11900336a80ec7c656b5fbf5276e175095e8479c5005e03a24a450b1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "483f37b11900336a80ec7c656b5fbf5276e175095e8479c5005e03a24a450b1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "483f37b11900336a80ec7c656b5fbf5276e175095e8479c5005e03a24a450b1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "700874578476a81b65959177967c3658af6b4e4c1ca257ae21f73f367ad627ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "119491a74674725198d87b322ae2dc9138f18390d9ba994c9bb54f3a2b25afe5"
    sha256 cellar: :any,                 x86_64_linux:  "e478141d83a77618ddb14a8f29e6f122d296095700fb4fca8700267bc8d4083d"
  end

  depends_on "go" => :build

  def install
    ldflags = if build.head?
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
