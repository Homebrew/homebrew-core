class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.22.0",
      revision: "b0adf910295107f689dcca6afb9fe2b397cbb977"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "676daf70ac43a52d7f5d795a0071eaa1b729489dab457146a5b08a84033a265e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b38b83fd88466155ac32c3868208acb98de906d485873e25a5a258fde4791760"
    sha256 cellar: :any_skip_relocation, monterey:       "32394c3162027975f12e432bf08dce67828bc8b2ff5715fffffa828ddf2b358a"
    sha256 cellar: :any_skip_relocation, big_sur:        "720a84cc09b510d657db151fbacd1e88924de6aef4fb9cac41acc1a6cf97a1fd"
    sha256 cellar: :any_skip_relocation, catalina:       "4c57808a6bb1ccaaf4acdb4a05f09962bf060e40533bd7da3f9fa0b2e565111c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5628f24292883e8ed10389e8647d1eaec223571a7b331cebacdfb2670525d0d9"
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
