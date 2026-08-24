class Ctrld < Formula
  desc "Highly configurable, multi-protocol DNS forwarding proxy"
  homepage "https://github.com/Control-D-Inc/ctrld"
  url "https://github.com/Control-D-Inc/ctrld/archive/refs/tags/v1.5.6.tar.gz"
  sha256 "7e20ce9a6fdddcf8029b8f581c4b9c1232f4bc49dd2742f37f155d4618f3dcb6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "465c855c7f15f9bc69bbfd394916a774f22de4d6b7b6a2e32878d2d6286a7ca6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "465c855c7f15f9bc69bbfd394916a774f22de4d6b7b6a2e32878d2d6286a7ca6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "465c855c7f15f9bc69bbfd394916a774f22de4d6b7b6a2e32878d2d6286a7ca6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8602bc5e657a908a06add75fad9303c25e64b022f35ec46a8068d04dc59e61a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71447537ec977955188836c028499fd424f1f94dc750a2c439e5ca3daec62cf8"
    sha256 cellar: :any,                 x86_64_linux:  "d5b04a6d8f8df6c5eed343675c297be8581f17cc80f41e473136483a238c08a4"
  end

  depends_on "go" => :build

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
