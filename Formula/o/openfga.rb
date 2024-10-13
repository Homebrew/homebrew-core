class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "d64fdc2eb57d018bbfecedc578dc50fdb9dfcd1ed8a9d35d1b3a7f3a4b1e9418"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73a403bce192ff8698eea956cbcf9096fae84d19e0393ee686670011915ff1ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73a403bce192ff8698eea956cbcf9096fae84d19e0393ee686670011915ff1ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73a403bce192ff8698eea956cbcf9096fae84d19e0393ee686670011915ff1ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "387b898f31e38b6c01d4df3426455c51230eb358c5f921145c7282ad62b8b418"
    sha256 cellar: :any_skip_relocation, ventura:       "387b898f31e38b6c01d4df3426455c51230eb358c5f921145c7282ad62b8b418"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e23bef09aa1142057725adc88928f8b23d9ab4bd02f568e54d28910746355706"
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
