class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.19.0",
      revision: "ae08da440a2cb20a3fd53a1ae4227cb03f5fac55"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9aed2527bc12a566e602c580fac99fd7b03b3e09765cb56f7718e5ad0a9ec24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "485d2cd11f7d4fb787192c871cecc245f8f16deffed6875871df0393c8f692b7"
    sha256 cellar: :any_skip_relocation, monterey:       "23d0785027864fbbb982d06655527511eec18ab0eb25a9d4d30fce44880ce416"
    sha256 cellar: :any_skip_relocation, big_sur:        "e175520c1d27dc336fc52e5935f3ab9f2d9c7090cdbcf6425684b83ec58ef27e"
    sha256 cellar: :any_skip_relocation, catalina:       "9a1d5282f749817a96f945506803e0a96ddc5980668059e0fe5363eaf812bb38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "994f7023215eccdc3031cf618f750daef0428ec4dd4e9d4ddc1f3d61c12d2656"
  end

  depends_on "go" => :build

  def install
    system "make", "official-build-clean", "official-build-version", "OFFICIAL_BIN=#{bin}/fortio"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version -s")

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
