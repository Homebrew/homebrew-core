class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.55.0",
      revision: "7d76c8ef1ea2b66f736b3d54d093ed0d2ce2a768"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4384729ce03c2c9c0e897800a7e00ed8188519ee0184de090f11d8ae5ef4930"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19f2e7d2cc112abc77c5f70acdc9a809d9cbc6e4e7790768b6ae5d317ecfa478"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24b56349114c1ff03ce9c5733c27361894b70a4445d6b284f1122b9ab3b2a8f5"
    sha256 cellar: :any_skip_relocation, ventura:        "e6b721cbf9328d7d4b7b1109b09aaf0a9705dd9ce0c793d251d167057185d697"
    sha256 cellar: :any_skip_relocation, monterey:       "15c917c9c3d1c21d2b5d4411828e5aa02de26604c6b3d49edf6e1859fda49759"
    sha256 cellar: :any_skip_relocation, big_sur:        "19d3d7d7a22421725244c75139a3af82dfd6ec15c27dae0e793d5fb72d1aad82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7e20f1e94b6a5b125ab5f9ee4e0c559473233760e7a1141895867645550566a"
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
