class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "7600d825494d22d1720bee84d2d45c9749958c15248182c751f297a72043c38a"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "169571400f3d08f5bacec7c0b2a35d76c3987d6d4d1d6f50d2f7e4d6a710576a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a081b10fa4d10ec5ce9f8cbbe53eda2abad9cc61ea48b1d6361d2762f9a8c08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "432161406b3055eea858a151acd9cb1a455e28bfabf9862765e1a9d95ff2ad6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0014d3a2fce89eee881c2e32e15e3563f0e6353a6a45c1bb9cc498cd4cffa6f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5ada044999edbc016f1ba30ea8c6eb8060fc2dc364c9db6952856e40c07ed88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58142b045800eea93f43cbbaef123be9981400ddfd4b350981ea9a838bc64084"
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
    pid = spawn bin/"openfga", "run", "--playground-port", port.to_s
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
