class Ctrld < Formula
  desc "Highly configurable, multi-protocol DNS forwarding proxy"
  homepage "https://github.com/Control-D-Inc/ctrld"
  url "https://github.com/Control-D-Inc/ctrld/archive/refs/tags/v1.5.7.tar.gz"
  sha256 "6f5c1b95c41260911ff64c7074333fffcb9b5122cc9826075cd8ee51024cc0bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0cb27d7b7da5fc00c2fd087490188f833228b3107fe4565c8432028b3c43070a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ddd7c853a1c6a9e965715c95f47f1332df4ec0ab67b231057c29e68424007c40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ddd7c853a1c6a9e965715c95f47f1332df4ec0ab67b231057c29e68424007c40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "ddd7c853a1c6a9e965715c95f47f1332df4ec0ab67b231057c29e68424007c40"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c34268bf3c0b7c155a9ba31ef093e04a383773031be73a24de7787aa82736dbe"
    sha256 cellar: :any,                 x86_64_linux:      "c0822141963f9d5475d733d53396637bb3fbcd055beabd3b246537057a9464de"
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
