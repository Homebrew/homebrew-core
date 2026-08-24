class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.21.8.tar.gz"
  sha256 "2e02b66958913e773d59e344a701d479e252457dcdc6be341e98428322c91565"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2eee32accd3ab7a35e9e214bc3cdd8536999cec7f42cbb4e13f6998ef680fd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2eee32accd3ab7a35e9e214bc3cdd8536999cec7f42cbb4e13f6998ef680fd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2eee32accd3ab7a35e9e214bc3cdd8536999cec7f42cbb4e13f6998ef680fd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "827bcd1ae5a34a23efc5dd9327fb65280cbe024a038341c658f6fbdb68f6ae71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e146a7f3212a2bbff08e669e2c8d04b5d0e9882f4c1bedacf0272b7c9ff54f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4f137da12a54396588f80d728eb1581833ce8446a5091bb95b9e994ae6857f2"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

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
