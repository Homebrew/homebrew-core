class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "bfc484ccc6c84ad3a521df232aea91fe78f3ddd081fab6c9ee6f296bffdff7f3"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57ab7dbd4a92c4b425a9107e81e9f575cd74e84ed90d35960de7a6860043d38a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20391158f7b941c559288b4128cea14b9a55831b7c134a8d829182368cbd0658"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d8d345532c8dcd429f1fa4a07051008b53aa8ea899829d6164235270206285f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbdfe19d2882f4012406e796afae32731c3cc93310661bbb550629973882bb53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bea2c2bf963fe298e438f80579a8aefba14d9587efa380e441133cad5dacb71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fc15ab7ae74f84c5ceae3cd4296fe0946cadd58fe39a500dd59b4453c986dab"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
