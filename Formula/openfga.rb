class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "553598652c5588ad416b1b0715bfaef23e26bf0c506fdf8d4e3502d55d469a9e"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef2dcefa37b8af0fbd4987345f2374fc013fac2f88f1e7e7d68d99a5f4beffe8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef2dcefa37b8af0fbd4987345f2374fc013fac2f88f1e7e7d68d99a5f4beffe8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef2dcefa37b8af0fbd4987345f2374fc013fac2f88f1e7e7d68d99a5f4beffe8"
    sha256 cellar: :any_skip_relocation, ventura:        "8d16dda013c8fbebc7db74309c575a55698816251af800a39d2fc36858a4a8db"
    sha256 cellar: :any_skip_relocation, monterey:       "8d16dda013c8fbebc7db74309c575a55698816251af800a39d2fc36858a4a8db"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d16dda013c8fbebc7db74309c575a55698816251af800a39d2fc36858a4a8db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e3b3afdf8686b4a5c76419692275e93a29aeb71c0f2dbd4370dc42b55e3488d"
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
