class Ctrld < Formula
  desc "Highly configurable, multi-protocol DNS forwarding proxy"
  homepage "https://github.com/Control-D-Inc/ctrld"
  url "https://github.com/Control-D-Inc/ctrld/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "d5914c7d6989091c8ab27c6fac7eeede5f3d86891e46a500d0f0fafad6120429"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d17c80032ce4eb3d9da29e904d219180a204c2480c0d14d3d9e717d3260fbda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d17c80032ce4eb3d9da29e904d219180a204c2480c0d14d3d9e717d3260fbda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d17c80032ce4eb3d9da29e904d219180a204c2480c0d14d3d9e717d3260fbda"
    sha256 cellar: :any_skip_relocation, sonoma:        "7063d0b7b044267cee6989e262806d2436280826ea27800ab5ef8ed69a15b799"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4445c3f8bc3cf3a09e60dde45dc27c2887580e49324f2b23be3c9620501041b"
    sha256 cellar: :any,                 x86_64_linux:  "391db0e3169ced99f99d91db25e4ee6c137493b8359139ca5a21e5d9110e03a9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Control-D-Inc/ctrld/cmd/cli.version=#{version}
      -X github.com/Control-D-Inc/ctrld/cmd/cli.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctrld"
    generate_completions_from_executable(bin/"ctrld", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctrld --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"ctrld", "start", [:out, :err] => output_log.to_s
    sleep 3
    assert_match "Please relaunch process with admin/root privilege.", output_log.read
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
