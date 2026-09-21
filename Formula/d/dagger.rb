class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.21.9.tar.gz"
  sha256 "652fffab225340df36ea4f65eded61628a9cf5f1dd2ac2f667aadaa5d84eb430"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "50b03fa939bbd98ec8fa950b07532d1799130fc8ceaabd27ac751dcde9b24cd0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "50b03fa939bbd98ec8fa950b07532d1799130fc8ceaabd27ac751dcde9b24cd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "50b03fa939bbd98ec8fa950b07532d1799130fc8ceaabd27ac751dcde9b24cd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "85007c070531eb0e900bcacdfe7a0b7773edca481670c698e37538d93f5c6caf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "92a103bd5fc95981c36181e67dd3c1be500513fd9398cd784561dc815abb39a5"
  end

  # TODO: switch back to `go` when x/net is bumped past v0.54.0 (broken with Go 1.27)
  depends_on "go@1.26" => :build
  depends_on "docker" => :test

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -X github.com/dagger/dagger/engine.Version=v#{version}
      -X github.com/dagger/dagger/engine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "failed to connect to the docker API", output
  end
end
