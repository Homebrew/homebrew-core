class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.45.tar.gz"
  sha256 "0e123669a056e746c0fd77dcfa1f3852e6e826a31fb332c5b20d0222a9cf0532"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32f26893dca79bd89bc08e4511e016ea5def6d08fd24fd39f135f2c51900e6a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32f26893dca79bd89bc08e4511e016ea5def6d08fd24fd39f135f2c51900e6a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32f26893dca79bd89bc08e4511e016ea5def6d08fd24fd39f135f2c51900e6a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec6950c9a00e7e1f9f22264a6b8227169d7f057ff1df9036067e32585d334581"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3c46fde5e999d365edce2d61dd4ad33ed7a023adee08d957927e950f2495483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d2661229a84c3de6411cc46775b9a42703fe3c918efa926262f7e9c93c90c00"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/depot/cli/internal/build.Version=#{version}
      -X github.com/depot/cli/internal/build.Date=#{time.iso8601}
      -X github.com/depot/cli/internal/build.SentryEnvironment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/depot"

    generate_completions_from_executable(bin/"depot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depot --version")
    output = shell_output("#{bin}/depot list builds 2>&1", 1)
    assert_match "Error: unknown project ID", output
  end
end
