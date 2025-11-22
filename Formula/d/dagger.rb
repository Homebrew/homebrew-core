class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger/archive/refs/tags/v0.19.7.tar.gz"
  sha256 "ee569a70092636d25779df53e711108f7edaa5beb7149e051801559386090689"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33142ab1d3a4d441d6f937935dfcdc68dc9fe0881e4d5711db312ece83ef9e05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33142ab1d3a4d441d6f937935dfcdc68dc9fe0881e4d5711db312ece83ef9e05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33142ab1d3a4d441d6f937935dfcdc68dc9fe0881e4d5711db312ece83ef9e05"
    sha256 cellar: :any_skip_relocation, sonoma:        "29a7dca87b86142b8f07363a0adf53d019b15836d0ab51c989a9d18962d0ec6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ead80740f5c9db4519d4bdccfbcc5572d16ecef930194d53fd8b7a8d1946825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bb28146071cd3732be8d4cc0bcb1c2ac5d636222dd27db707b3db743b415497"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
      -X github.com/dagger/dagger/engine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "failed to connect to the docker API", output
  end
end
