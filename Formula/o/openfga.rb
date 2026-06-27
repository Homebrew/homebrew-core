class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "d63f8ddd7b01546c14a35cbc18b9c75db41246ee6230f6f136c8950c72e77d97"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c2bda3b373a74a701c5943546817b4d778109d5293c1013eaf22c50317871aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e1b9cfd2ebd3f2423b7d37cacb0adcb2e84dfb5109e2ff252a306af212991ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6763c02cb5c74c35f3683ed1e58792e23ce7329fb0e6e378110dac7c95bd43c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "aef85f6200405db24f9b3bbcac31b49a25873560158939bce003aeaca814596b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35771ce1569829d4e3f14f34b1593138b01b31b96b80d3f40ac9040e553c6d80"
    sha256 cellar: :any,                 x86_64_linux:  "62f8dbd2eb83cbf86f7d69947080cc25240e202249cf4da717fc95e1aa7a0cc9"
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
