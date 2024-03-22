class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "0cf5fa105b7f255ba02e77b3ea8f507da31cf9f94a7d3c278718c60b8f9e0f40"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91782a1654ea09580a6a001f9d78060607bbd7350223e7e9dcff6db97fd545b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1255c925926c7e58e9c5037d4c2b32ca259aa784145b9efbcdd0d0e16fc9769b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "796ce072cb7d225074b234f8023d0f0c7dcef4de6ebeaae6d73d2eeee498d8e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "d912911ab4e0e0d7d09feb1ca1ca6698a1059d0402568c987ecfd21521a66b85"
    sha256 cellar: :any_skip_relocation, ventura:        "30d433d0807a982f8321cfe9f1a163c9867422733862ba77ff387b1e7f8bc2ab"
    sha256 cellar: :any_skip_relocation, monterey:       "b435a7a7cf592aef3df0a25cde5af4de63f53797f9ba056bd42d252048dbd3f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f15c2cd614cebdfe7d8e07904f600e1d58400fa9b791f88f9891a39116fe376a"
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
