class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "0438e84a0d29eb902d50d959213e619f4040c0b59697bb2a2d108386744d67f9"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "85f82f089f9734cc1e1e5063f6d2788048a56959b8b2de6e77e2fe5a67850aa5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eda1d710832c56bcb724d70a16e6edd9aa3a5441142b815925343e593484daaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf860b22ee3547fed27dfa1966f4df1d625c36305af3201567926ed087680889"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0bf8ae9433f9178792c52012ab678b6429f2f9c8c0f4c713cc3dee1e4d05462c"
    sha256 cellar: :any,                 x86_64_linux:      "2c82fd43e7c37bdd5efe2327113a2ee09118ea52e2b5e5c8e1876ab8fb571989"
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
