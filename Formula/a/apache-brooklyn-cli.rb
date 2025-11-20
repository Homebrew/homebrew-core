class ApacheBrooklynCli < Formula
  desc "Apache Brooklyn command-line interface"
  homepage "https://brooklyn.apache.org"
  url "https://github.com/apache/brooklyn-client/archive/refs/tags/rel/apache-brooklyn-1.1.0.tar.gz"
  sha256 "0c9ec77413e88d4ca23d0821c4d053b7cc69818962d4ccb9e7082c9d1dea7146"
  license "Apache-2.0"
  head "https://github.com/apache/brooklyn-client.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^(?:rel/)?apache-brooklyn[._-]v?(\d+(?:\.\d+)+)$}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "40f8748f92e5bf30f1451b1590f1bcfa7d2cb4001b3b464a3cba2536207dabfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "503ba57fecdd845c589d3d989e55389df542bf408d74c6b6bdaaaaa3b9fa9d7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5d4f837f66feb0e8ffd454caabde1262774b0146b9a41bc7b0e6c8db2f12d35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3c1f6d82e0bded1a9caed523d74fc56bde05a5a11dade96496475ff43064f7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb10e0929a320063dd6ff2bddef8b222600696bc54186be67d390194b4282c88"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c95c57b459108b4ea53b4ad26ac0fa1f5f63bb7d48f4af8cf213f052e35235b"
    sha256 cellar: :any_skip_relocation, ventura:        "93b0fa4d3664559fd801cd65d4834352cffb39b5328ae8ee8b983aa379926add"
    sha256 cellar: :any_skip_relocation, monterey:       "0478989b79dde26f28cb82612e4991cc7f9e0255ea4d5db7991177083b77f036"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2ad44e932f78810e55add04db3a881b3ed6f0f90b9869ec404f37c17e690331a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7c85e245c2a3ba2ed68c1e2a64d9b6bbb7e1b0dbd5f1a4f3d941d0e0f19a25e"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"br"), "./br"
    end
  end

  test do
    port = free_port
    server = TCPServer.new("localhost", port)
    pid_mock_brooklyn = fork do
      loop do
        socket = server.accept
        response = '{"version":"1.2.3","buildSha1":"dummysha","buildBranch":"1.2.3"}'
        socket.print "HTTP/1.1 200 OK\r\n" \
                     "Content-Type: application/json\r\n" \
                     "Content-Length: #{response.bytesize}\r\n" \
                     "Connection: close\r\n"
        socket.print "\r\n"
        socket.print response
        socket.close
      end
    end

    begin
      mock_brooklyn_url = "http://localhost:#{port}"
      assert_equal "Connected to Brooklyn version 1.2.3 at #{mock_brooklyn_url}\n",
        shell_output("#{bin}/br login #{mock_brooklyn_url} username password")
    ensure
      Process.kill("KILL", pid_mock_brooklyn)
    end
  end
end
