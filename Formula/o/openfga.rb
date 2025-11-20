class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "2a4f47a3b19f9f6767f4bbaaa6edb68596c41e649dc7bff8c687f33fd1909c33"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b038b4b8dabffa915c538d5edbd0f79630542f57b0d9602b02f51d23279fb736"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23e36cda9ca4e1ff33c8ab851de5e7f11e83f35e9f905a4a8dc223e7d2aa6f41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2e0850e01623633298ba3912e8054139056ae4bec0f4ead5e37c8304f885936"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b9d682d86b97e9563585bd896b713f3294cfa3ecdc720388b74068858247d0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff9420afe25583211c736f5a5c7a76a25c4dcd9d3080835e79c8a0e88982f522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6b7792287bb3fcd4d8b42e91ee4b1e08b42b4a65ee06b29489654fd2056926b"
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

    generate_completions_from_executable(bin/"openfga", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openfga version 2>&1")

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
