class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.63.5",
      revision: "7fb716245cf997528f4b035549277000521863d6"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6432c6bed74ce66d09febeeb8e64e0b6e7dd5aa86869a1c2b6ca35c59db1c8ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3af0e82e77570b47f963e05bffadc98f7f58d76db48ad73b9fc814be12a5a99b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "483a0703a11fb351a45f2c0ce35fa92a5f7d217c956b76b14a5b381cebe0e536"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bc417afa74bdb4f722adbd101b609c26901a422f26ffb15f54a39eb15e2ffb4"
    sha256 cellar: :any_skip_relocation, ventura:        "3d69375b48f9155743b498c2e6aee852ebd20744dee6c38cfbc22812f7c48425"
    sha256 cellar: :any_skip_relocation, monterey:       "5d0a0adb915fe46093cbfbca910a83d55fede385aaacd1cf2a9447468b9e2461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "640b91e1a662eddffd82cec8fa45ac8a7048d1e166743c615f306fd65b0dfdbd"
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
