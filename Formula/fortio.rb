class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.18.0",
      revision: "c0e5fce3ea4bbe623481c15fcd8dc81beb553aec"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b572098fbf2684a8ffaa6c54690f31a2cb1ef0fd535586ca32ad2ac483133f40"
    sha256 cellar: :any_skip_relocation, big_sur:       "7dd404a3c3fc30f3a7cb734aa014316bcbb6619dbeefe04b00d5c2fb33ce03cb"
    sha256 cellar: :any_skip_relocation, catalina:      "360be85e8276565991b0eebd312e60d43d3d110a0a9dfe492c4a0c26e56ca8f3"
    sha256 cellar: :any_skip_relocation, mojave:        "df0f5017b826295a08475451cff6bfa33d4b00517ee1643a304f6b97e159bf4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afbb79748450db3153622ef148f190e560a1fae99370efe958d6c77a1e3e4f8a"
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
