class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.18.3.tar.gz"
  sha256 "096816092357dbe0eacccdf18bff72484205228975de70b58427d42ab87cc472"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d30078a8e2b3f206b2e89d65e63bbcaa31b6dc9e4b1a6e6ccba750de212b9038"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b44a0c40102cf6d350cba1c082f980ae0a3a28d3b84471f057cc0e3b0e080180"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6db8862a9514c41924f3ff0f8dc95b638615225d218a4cc03e3f034991c4c643"
    sha256 cellar: :any_skip_relocation, sonoma:        "720987bb331ccefd087ed543c099d0f4a2739406ece212015b74a900a6c6be1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eba3cc9bb80872a5cd006a836c9db9bb77e88dff3d650c9375086ee977502040"
    sha256 cellar: :any,                 x86_64_linux:  "257c746b6e8f06237d5095371b6c509d6cffd64ca910ea2aa062dbe8ac5e30cf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=#{tap.user}
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openfga version 2>&1")

    port = free_port
    pid = spawn bin/"openfga", "run", "--playground-enabled", "--playground-port", port.to_s
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
