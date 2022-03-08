class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.21.1",
      revision: "7965771ec8feec9de2e1c6a3752c594aee7350b0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5f5baef5a0b6a5600b544615092bb373451ab54539ac3be22a1b392e407869f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "382db4ecec6275d083836e2ba6763e9add3339fc50a51395309ea6ce4d2bbe6c"
    sha256 cellar: :any_skip_relocation, monterey:       "f320e802e5358e91e088276b9dcfb76aec919e199ba7f19e933b14af873615c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae874bad25fafa787192bff0aa8bd044e3a536dd9a50975c4e747a81b4e19543"
    sha256 cellar: :any_skip_relocation, catalina:       "42481ef697adde83f697ad41eecb5547edc7ff69be6378eef13e4805f4c3b3dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c5aef4ae9a22f7ec0a5225855d4b4a130b208f23c27310529d85e32c2247b4d"
  end

  depends_on "go" => :build

  def install
    system "make", "-j1", "official-build-clean", "official-build-version", "OFFICIAL_BIN=#{bin}/fortio",
      "BUILD_DIR=./tmp/fortio_build"
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
