class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.67.1",
      revision: "16186b8ff17306f9e4a30c925911916faa641fe5"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0be942de75b61e42e52285ac3b0e96cef94a90bd73b2a49865df8217a02034cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6126ba24ec10d2a7c69c23cace0207a4af2591d591479c45e9cc92d15e56a210"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b28c294ab63523a8955312cb16c5dad7bde80256258686cf9721857a9b0990f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9ec859b4dd5db8b2be13d6bb984ccc0eb9820103a4d1b12957d73543396722a"
    sha256 cellar: :any_skip_relocation, ventura:       "fe701efd1db9de289a17205c25575492c3554db8f97866f9304d51d933d72436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7e43c41239e8040819de59d98e7b62409aaa63a6fd8cad980b8d85d9e60dc28"
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
