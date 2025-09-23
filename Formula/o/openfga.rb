class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "a938f9c9a5c9ef86ca63d19de4df6e37d5f81ef1cc1f5ab896ca30b49adc884e"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3f011031399b098d16488a3d613d7189f14f505c101979ba0c90efeabb9337d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d691a8ebe7ada32a9a1668638f31a92e2ed4593b83c752fcb4e87b67d1696a4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "008c86061f7b82f7bc8749d7ae1a8a565075c860bde29fddb290bcdb45738ce0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5973957e4bf06be1cc5b824c4d7b3be03de9f961e776170bd4ae0a9f7ab938d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20b4964e75295cae85a2d9f609aa92caebaa307e303551ea470c0ef748884ccc"
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

    assert_match version.to_s, shell_output("#{bin}/openfga version 2>&1")
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
