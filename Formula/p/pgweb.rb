class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "1feb51c8734e0368795172cbd5bcc92ee4e55075c17439b242e4d982bd8debd7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff9b86b547ac18a2fd44a566eb597dd907dcfb938db12a24541f1745251ce67d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e28187b749668c50fcc99dceb44fd523ac662b02769bfc88ec2700996261bfc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f986dc24356be84d7b2cfc2d5d04185c11a4dd62864a2963b6f74125c17fdaae"
    sha256 cellar: :any_skip_relocation, sonoma:         "f733b9fb25a9605e5aca8ab0e0eb314ad234337be9bf5ec255f39ef609f98129"
    sha256 cellar: :any_skip_relocation, ventura:        "1bef1745958af37b1f11d0b8dc155ea199568e3d8951fec050a64399da65c2e9"
    sha256 cellar: :any_skip_relocation, monterey:       "bfdbceee37b804fcf2aadc54f86a093a257cd7c561f444d33e47102c842e46dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8964e2dc4ed313c29a4b1e0648acda14dbea61ea9bd4ce072e12aae70c742137"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/sosedoff/pgweb/pkg/command.BuildTime=#{time.iso8601}
      -X github.com/sosedoff/pgweb/pkg/command.GoVersion=#{Formula["go"].version}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    port = free_port

    begin
      pid = fork do
        exec bin/"pgweb", "--listen=#{port}",
                          "--skip-open",
                          "--sessions"
      end
      sleep 2
      assert_match "\"version\":\"#{version}\"", shell_output("curl http://localhost:#{port}/api/info")
    ensure
      Process.kill("TERM", pid)
    end
  end
end
