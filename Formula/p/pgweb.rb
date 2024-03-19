class Pgweb < Formula
  desc "Web-based PostgreSQL database browser"
  homepage "https://sosedoff.github.io/pgweb/"
  url "https://github.com/sosedoff/pgweb/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "fb8c324d8c7c6efd144cdb977b30eb0ec2b2051b23c97ab6a7a2be578e1247b9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b288febe1f825b78896380ced8b8eb102e931c6d0161aeef2730a2ad209a586a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33d0366dbef19c2b6fd37edfa18cdd7dfe16548937b9c73823b37b3f06a198de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b39da436e0f405c7411043a185184499536903b0196e5f9da2c8e14382e4c07"
    sha256 cellar: :any_skip_relocation, sonoma:         "71b4c6118421e90e5a45d9f15dacef4bff7c168e7a269fb9f0ee865e8be99dac"
    sha256 cellar: :any_skip_relocation, ventura:        "b7b0bdd56fc97b0cfcdfeb7dce6c7633bd4f684269fbb23dc25edd2b34e0bb50"
    sha256 cellar: :any_skip_relocation, monterey:       "adc190dc233335c32cab948645157966dd4cc6c9b53e89235d4784200c88580d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a431ebeece760c1a764c46970da095e30cc34655ce422400bfeaac3e60fbc5d1"
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
