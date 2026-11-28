class Ctrld < Formula
  desc "Highly configurable, multi-protocol DNS forwarding proxy"
  homepage "https://github.com/Control-D-Inc/ctrld"
  url "https://github.com/Control-D-Inc/ctrld/archive/refs/tags/v1.5.11.tar.gz"
  sha256 "2160a086b9113c5edb1df577390d7d4bc0a73b1ad856cc37483cef65889b63ba"
  license "MIT"

  bottle do
    manifest_sha256 "73e9fc4670ea0e74881e3ecfd4854838da24456e12ccc23fcee2d096ff068950"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6767b9ef0c299fa0499d017032f477216a5d1600a69c86c792832882b21dc1e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6767b9ef0c299fa0499d017032f477216a5d1600a69c86c792832882b21dc1e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6767b9ef0c299fa0499d017032f477216a5d1600a69c86c792832882b21dc1e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e4edebece93ea6ed1f8259eab792afb858fdd4a6a751f9a5bf2cb7d4b761eec3"
    sha256 cellar: :any,                 x86_64_linux:      "2ad678b70d508067f20a0e2bc5b77d67868db51cc0ed9c7bdbd85c30d31c298e"
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
    with_test_process(bin/"ctrld", "start", [:out, :err] => output_log.to_s) do
      sleep 3
      assert_match "Please relaunch process with admin/root privilege.", output_log.read
    end
  end
end
