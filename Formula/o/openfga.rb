class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "f8a9ae6556729822549bad6db7ea7fe6d383ece4e79d755c1cf28bff59f94894"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c4f946190bb56685bc696df29e5ede74e7e04891ccdf7b63a97e170e21128a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfc9ae87bc4c4b0be582057a00c0f2097d82a852f058c9281c00518d3d69a3e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2cd4dd9942dbfe6d7d4dde784cb3710ed28431a1d3b7f8ec4d655ad3b913189"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1add50652669b9246f9aa6a8ba7a4d766a7d6c8d9d1e8a6bfc0161fcca23920"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ec354ca6794d1e123a80cbc93fca6961bbe57e605ddc5b75f739bf6dd90eb4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3fb5c87d7ef247b47fc3ee889980130dd9c6e19efe2df3bff779a77e425efb5"
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
