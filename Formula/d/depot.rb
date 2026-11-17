class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.103.22.tar.gz"
  sha256 "6e385856d7b494fb055fe9e3a7cfacb0036a71f36dfcbc9c797e5ba9c39e3946"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "75e452f89895a935799e9754aeb8791d45aed812bb1b68e8d79ce8003457e95c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75e452f89895a935799e9754aeb8791d45aed812bb1b68e8d79ce8003457e95c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "75e452f89895a935799e9754aeb8791d45aed812bb1b68e8d79ce8003457e95c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f07caa05b96d94fc805e2ef029837e60ee347dfd173c8538e7ae715f6e9dc037"
    sha256 cellar: :any,                 x86_64_linux:      "f4e5a52b013fa342c4d1a8235a1b85794a3972a797ea698e9e4103645e17f6e6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
    assert_match "unknown project ID", output
  end
end
