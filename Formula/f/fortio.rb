class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.76.0",
      revision: "67ce9fa2a3a62fdb2f7a0d2b50acda1f7002d32b"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "854989c7b8bfa790956b9aa50caff1a780dc835e70d33534108ec3bdecad3581"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2436c65dc2ee54f2c177206ae4f023f659df343fa921f161b7ba202586c4e7cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "67f987b5ad193170817b4c0e97dfc37140c3cffe67731bd9feded935ab8c9547"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e8bd405659535b5e6c6abd81f1af5f493080ae0cc86007987e8c30094041a655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d77c2692ecfb4af0a0b763fa8a18e7e90c5780304695e9ba87b1fc85dcae4204"
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
