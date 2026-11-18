class Ctrld < Formula
  desc "Highly configurable, multi-protocol DNS forwarding proxy"
  homepage "https://github.com/Control-D-Inc/ctrld"
  url "https://github.com/Control-D-Inc/ctrld/archive/refs/tags/v1.5.11.tar.gz"
  sha256 "2160a086b9113c5edb1df577390d7d4bc0a73b1ad856cc37483cef65889b63ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ff8855ec21564596582079205919222dfa67fdb9f65e758e6a66027ac6a0014a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ff8855ec21564596582079205919222dfa67fdb9f65e758e6a66027ac6a0014a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ff8855ec21564596582079205919222dfa67fdb9f65e758e6a66027ac6a0014a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "588a00b0aa207040f9a656ee1de882fa9a0ffbc21c2a791a5c3787d77f4b488b"
    sha256 cellar: :any,                 x86_64_linux:      "89a7bd3bd945b4e9af93036426b724c38af25dc16871ca85d06dc9c9e6005f1e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
