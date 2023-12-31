class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.63.1",
      revision: "63083144350d8b9acabd2908a51b2953c9f83262"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0bf5e80ec69578971f8c50c6f101c590beaa385ab998a6b6a13f6267ffc17fc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f27d180c970793e1bc7ad305d812a2a6c0a56ae30a73ff408862b98115a4c8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f78f70ad21e1e04f1ef4618f341abdd16180d3f61a241871ace7141bf6fa51f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a58b78e850c04b221d20c55885599e3dc231cd2b6557d58621f1809fd204618"
    sha256 cellar: :any_skip_relocation, ventura:        "5b2fc82693b665425df90a19360cc7989aa16a6908c02b1d26e693f1a4cf56b9"
    sha256 cellar: :any_skip_relocation, monterey:       "d80e5b706f65a8bf8399f03f8b8637decdd47c671c5f168d059cc2be57fadd9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b815c82f68bb8320a27f3b45d84fd7fd9f28c8fee3138b36894ed070a20b59d"
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
