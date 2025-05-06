class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.8.11.tar.gz"
  sha256 "b4528ec6a4bd913cc892a86f85b3badcaae5a8e474d1169689476b2b591053db"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d939a1d8fe8248f07b07d8fd7b58f6d129a8a65c8c842cff848580e63afa2e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50906d4c5092de16823e5ddd13c53959236942296d958223e8db47fa67e42a4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8904a897340f28e8d3ab92b160b6db160b88d0002563fa51aee8db0de9008f01"
    sha256 cellar: :any_skip_relocation, sonoma:        "356ce312056e53683278c5246d8d8dc26f9faf6c2869cc818c8437636072e8c4"
    sha256 cellar: :any_skip_relocation, ventura:       "2f6aba2b4041fb0521e7d3e0d3c892a56b151b19c11f62aceebc16c20e0e9b61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcf3e46546e99d67cbd4815825d0d5b979f32c50a5f9eff2e211e6e3e74120ce"
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
