class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.73.0",
      revision: "889ff4c4443b9bc4c4c2d843822d6a8a1e8aac05"
  license "Apache-2.0"
  head "https://github.com/fortio/fortio.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b6202bd590936668dc9b5c05d62a8f8aa60a86aab31ea525ca40bebd70f83eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b6202bd590936668dc9b5c05d62a8f8aa60a86aab31ea525ca40bebd70f83eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b6202bd590936668dc9b5c05d62a8f8aa60a86aab31ea525ca40bebd70f83eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f525199cfc58bd656085cdee2b7d10bb50ebf6002f1d2019d8427a2a4fc883d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dd28e35bede48998e309d61f7a4890267fd605c089a8189a886b820e21d7748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bb82a484bf2617339f90f751059253a2dc9151b228072baff38c47a0dfa6902"
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
