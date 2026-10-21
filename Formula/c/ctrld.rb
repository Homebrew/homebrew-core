class Ctrld < Formula
  desc "Highly configurable, multi-protocol DNS forwarding proxy"
  homepage "https://github.com/Control-D-Inc/ctrld"
  url "https://github.com/Control-D-Inc/ctrld/archive/refs/tags/v1.5.8.tar.gz"
  sha256 "9cf8971abab920cc691bc5a9da5de16df31e3b2bec26a9d14a0652b18eb33ce6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e5e1c9ae933fdcaec9d07d86e867be0078cfcdfad1b002e04d40eccbde79bcde"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e5e1c9ae933fdcaec9d07d86e867be0078cfcdfad1b002e04d40eccbde79bcde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e5e1c9ae933fdcaec9d07d86e867be0078cfcdfad1b002e04d40eccbde79bcde"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4b0fc00cf64d698e62b2462fe5539833ed4a86c1475d4e512e5a3ecbbbc49dfa"
    sha256 cellar: :any,                 x86_64_linux:      "cecc9b7e31579c5a45ae4fb6e601dfe2a8597a00939252cdf7330d15b7d4bca5"
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
