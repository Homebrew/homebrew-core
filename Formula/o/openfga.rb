class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "75220e705797fdcc5baae5b739eadce8a5ebff0db337189850e0be1297ae2545"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "689974899681560ae5b1db4c94af0589a4aaee21c255491374f4e4dff28da1ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "689974899681560ae5b1db4c94af0589a4aaee21c255491374f4e4dff28da1ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "689974899681560ae5b1db4c94af0589a4aaee21c255491374f4e4dff28da1ae"
    sha256 cellar: :any_skip_relocation, ventura:        "6d5c5355555b2b3719668ce457fa0e610a97412dd75ee3309614d7a2d552482a"
    sha256 cellar: :any_skip_relocation, monterey:       "6d5c5355555b2b3719668ce457fa0e610a97412dd75ee3309614d7a2d552482a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d5c5355555b2b3719668ce457fa0e610a97412dd75ee3309614d7a2d552482a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afbd2415bd9a8e6562eacdd2a829a19ad1c631847e13c02d06636529e3ea2a06"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=brew
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", "completion")
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"openfga", "run", "--playground-port", port.to_s
    end
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output

    assert_match version.to_s, shell_output(bin/"openfga version 2>&1")
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
