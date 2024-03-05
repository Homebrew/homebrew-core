class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.10.1",
      revision: "e04ce8a9bd8a865e0c1b86b272128cf8ffa0e62b"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f658dd67fef2d8c59d51db143f64f0fa1714f0c27b4cdce42214124a1c6ff8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "651cdc55c52644ee279f86698ec67441561e0c0f7c172248477fd621537d5cb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2160b58d10bf33cd7c7e720b24eecce209aef82b0c540dfc32d8af506beabe9"
    sha256 cellar: :any_skip_relocation, sonoma:         "84566049eead4094c4bdf04a1d772844cf689c7db0d5b0aff62dc1da61e4fe2b"
    sha256 cellar: :any_skip_relocation, ventura:        "6fab0cd0c9d05fddbd2f2672a752807bb905c7d18ea59ae9694b3bdb50eea027"
    sha256 cellar: :any_skip_relocation, monterey:       "e985736fb0dfe2dc7dab0dba49b8b74cb3979e6971ba5498ffb40bad64bb2212"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6e3062395bf2f00bf1815c4ef9979beb9ffae88cd857003d10869c2ee89a300"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
