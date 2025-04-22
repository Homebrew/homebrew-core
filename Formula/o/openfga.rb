class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.8.9.tar.gz"
  sha256 "45dc6c00342d7e6374cf9e61cf024341dbdde84fc58f1d25c6780f0aef4f7374"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50205de0c0b7570cd54f4a5dfafeab1205ecdb3d974dd2e27f9722818b832488"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "647cbf0593fbf6ca74dbcb9389e8975be79e5be97cfdc90397852726106f5b15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "279031fa2470cdd37a72f4525fcac00b4464300ffdc17f8c2c4fd7e0f6c45b68"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4db2bbb8efc6da04f97f073284223ecd58bd1baf450f594b0dc7bba3e6e399e"
    sha256 cellar: :any_skip_relocation, ventura:       "0cf34a3e47ea0520d5284a209e29b15e500fe04b778bdecd507dfcbf25732161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10030e9f9e17c6ecd468ff36275f7ca0d037149ce0b7c92cd791d44241e7723b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=brew
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openfga"

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
