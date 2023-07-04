class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.56.0",
      revision: "8890d97fd5aac4ccf571cc9a40331d3ab2bd145b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d445648b7de8a14fb48781fc4ca27571e82aa81ad4024bb1aa78fe8e0b94bc4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79348040364ea635d92dedb9972cd9de744cca1234f8e6f6028098124b1a3a78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d31d899843529651223e682b26afe6a69fcb0175e92cad4b50ad403637a89d4c"
    sha256 cellar: :any_skip_relocation, ventura:        "b458033c3fdcaa03c506616eabf9c75646e0a177854be55cbe15a0dbd992fbdd"
    sha256 cellar: :any_skip_relocation, monterey:       "bff9d4278ed6bff25c29a272bc6b064e15c612a3684c65e934ccad3c1767b0be"
    sha256 cellar: :any_skip_relocation, big_sur:        "67eb4e253442231d27647a0989f3a5a854a81cec19b4d3e9e1b03245f6ebe0d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06f575497fbd1703ca52f8b48648d8488337c9f6e8f9425fc5bbd530395726b3"
  end

  depends_on "go" => :build

  def install
    system "make", "-j1", "official-build-clean", "official-build-version", "OFFICIAL_BIN=#{bin}/fortio",
      "BUILD_DIR=./tmp/fortio_build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version")

    port = free_port
    begin
      pid = fork do
        exec bin/"fortio", "server", "-http-port", port.to_s
      end
      sleep 2
      output = shell_output("#{bin}/fortio load http://localhost:#{port}/ 2>&1")
      assert_match(/^All\sdone/, output.lines.last)
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end
