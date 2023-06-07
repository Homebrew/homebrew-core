class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "2534b5c9b85c5abf177211b6070f5d2691817196ee6d1c31d4f9ca038602a34c"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2fed5e9c2cb89df90a9ab3e11b92cc354838edf58e2e10bc60a841e8422e40b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2fed5e9c2cb89df90a9ab3e11b92cc354838edf58e2e10bc60a841e8422e40b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2fed5e9c2cb89df90a9ab3e11b92cc354838edf58e2e10bc60a841e8422e40b"
    sha256 cellar: :any_skip_relocation, ventura:        "8ae75a911c2afdcfbf02e7a5958d2072b434c590dfbecda9df5122e7492d70a6"
    sha256 cellar: :any_skip_relocation, monterey:       "8ae75a911c2afdcfbf02e7a5958d2072b434c590dfbecda9df5122e7492d70a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ae75a911c2afdcfbf02e7a5958d2072b434c590dfbecda9df5122e7492d70a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c7e0022865423a46575c3684ac853646f360b49854621c6b54fa41dacd3fc5e"
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
