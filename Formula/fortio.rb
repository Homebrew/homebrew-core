class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.50.0",
      revision: "d1d19b6d862c57ef2b5394e21d954d1df6d4fe70"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d0be3051ec784176140d5d512d172886431d63977c49103d0430e424512cff0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aaf63720df66496e272ce435135b27134cf5fdd9e943ae9860ec41b446cd9802"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "915ffcf89b9e4febeb2f7f64a0382d7d1f7333235599d33dda6ae2f7aef5d7a3"
    sha256 cellar: :any_skip_relocation, ventura:        "9244ed06094ada85578094584f4aeac0e562f9ea5aeb062dad1a05ed52657813"
    sha256 cellar: :any_skip_relocation, monterey:       "24ab649e7d6f41c39275cc639be46f1a9da76b53f43fbd84c5f7e375e09fb920"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cd8b16162efd8507ba48cdfb41cc4ef3fce8e9daff0fdb53c0da1edd4cae47b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daee0cc15ce55541e091382b21f202595040e9f8823e5bb7878c78ee4a77d6dd"
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
