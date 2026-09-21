class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.75.3",
      revision: "5c19725ff61c9f7ad944b91ec32d96a399341d87"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "adae032905a9a932ce31f4883dc8d907e32586740ad5886d181566ed893b200f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c066d17408ceab9ac6891a86e5a714d088b3f20debe47b4570cadbd49914bdf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c066d17408ceab9ac6891a86e5a714d088b3f20debe47b4570cadbd49914bdf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "c066d17408ceab9ac6891a86e5a714d088b3f20debe47b4570cadbd49914bdf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d9cf405df21a5cb11b09e33baa5396860c980f2710fbed32ca94f2fde3aaca35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a8a6de6c00b2c4d501b4a813551628d33d475339c724bfb87f3185946d630de8"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "make", "-j1", "MODE=build", "official-build-clean", "official-build-version",
      "OFFICIAL_BIN=#{bin}/fortio", "BUILD_DIR=./tmp/fortio_build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version")

    port = free_port
    pid = spawn bin/"fortio", "server", "-http-port", port.to_s
    begin
      sleep 2
      output = shell_output("#{bin}/fortio load http://localhost:#{port}/ 2>&1")
      assert_match(/^All\sdone/, output.lines.last)
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
