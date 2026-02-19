class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.11.5.tar.gz"
  sha256 "678814ba927a70d9ea44bfbd46b9adb63f50e5b3c9e77e2fbe9f483a3d5f4735"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "897b659992de8937e9b11f5a5bed0891c09328aac53c1b5e0ed97edca6a1d675"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "963d1e5716c9c415c9db886f9193f0f34b14b26f3dff94593c70b18fad996e5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a088ac4bb591434ff68ef60127349a1d152a9a0faabd1c0454ad4d6f3d3d02b"
    sha256 cellar: :any_skip_relocation, sonoma:        "910cffc6a5fc96e7fe140b57cf1de63e170ab24bfb99dafb8ba10e8145c8a54e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9e372c3a48e89417d90d04ce06e3ea9cb0b2292043ad354d5347019d3d4d7db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaf743e798754bab04b6d2e33d06e76a191552aee3d3c569d1078a6e76066c6b"
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
