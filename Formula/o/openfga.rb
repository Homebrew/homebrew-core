class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "25bd5d99323682b36e1dc368e09d312494a754fd364e6acefafba7557ded991e"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbad708604dd1c0b41986ea596d34498bde5d080e55f1d59679642c75cd7ce46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95d866d46e013715a65027b45ab067495058fed57338e6228b6282ab0b5a959f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7cce43f30ddbedc7df0fa4dcb9e3723bc487bcf207af0ad256b476d90d9c2a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe152d9da1b29bc62558da2883432215bfc4d042bb6d61d314b3b9351dc54c3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a9ca76586f7ddec26832fa9f43c5b7cb46631b3a4a7bcfc13ccb7c4b109bd10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "751510e0dd8c71583e6f22e34942050c3493b190a8e5738c7a289abb41d0aa5d"
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
