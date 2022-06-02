class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.32.3",
      revision: "56fa5ab3bb0f93af404e124cf17f3f341450adc4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60a353378dd626f689ed1dc862cec982145198fd2cc1851fbad3717867acf039"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ecf74d934c77afa37143a4c90f6e6fb8c2117efe28c883c9bec03a7212891b55"
    sha256 cellar: :any_skip_relocation, monterey:       "b67219de640b7a8cbc8ef40cb03a72e511d8885118cf0d1910bb22651e145a20"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e03212a0ce4d401cbe0a7745a677d47466aab43a2b3f8187a8e00bdcd6a740d"
    sha256 cellar: :any_skip_relocation, catalina:       "a6206ae9f90e5a9e2114f4f467d927fff173d04069ae277d7ef8e466e4f0f0bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77ec9e8fb747627059e45825c6db5f1396d112f7b8ea67e8dd5fc2fd8740cd7e"
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
